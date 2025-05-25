defmodule ChatApp.Service.Sockets.Client.Server do
  @moduledoc """
  This module replaces the GenServer for handling client connections
  and communication with a remote node in a simpler process-based approach.
  """

  require Logger

  @reconnect_interval 5000
  @remote_node_prefix "server_node"
  @service :server_node

  @doc """
  Starts the client node process.
  """
  def start(ip) do
    spawn_link(__MODULE__, :init, [ip])
  end

  def init(ip) do
    Logger.info("Initializing chat app client...")

    :net_kernel.monitor_nodes(true)
    remote_node = "#{@remote_node_prefix}@#{ip}" |> String.to_atom()

    @service
    |> register()

    connect(remote_node)
    |> initialize_app()
  end

  defp register(service_name) do
    Process.register(self(), service_name)
  end

  defp connect(node) do
    Logger.info("Attempting to connect to #{node}...")
    Node.connect(node)
  end

  def initialize_app(true) do

  end

  def initialize_app(false) do

  end

  defp loop(state) do
    receive do
      :reconnect ->
        connect(state)

      message ->
        Logger.debug("Unhandled message: #{inspect(message)}")
        loop(state)
    end
  end
end
