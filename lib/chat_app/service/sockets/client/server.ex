defmodule ChatApp.Service.Sockets.Client.Server do
  @moduledoc """
  This module provides functionality to connect
  to a TCP socket server and facilitate communication using GenServer.

  ## Features
  - Connects to a server on a specified host and port using Erlang distribution.
  - Sends and receives messages over distributed Erlang connection.
  - State management with GenServer for better reliability.
  - Graceful handling of connections and disconnections.

  ## Usage
  ```elixir
  # Iniciar el cliente
  {:ok, pid} = ChatApp.Service.Sockets.Client.start_link("192.168.1.100")

  """

  defstruct [
    :remote_node,
    :ip,
    :connected,
    :reconnect_timer
  ]

  use GenServer

  alias ChatApp.Service.Util

  #@service_name :chat_app
  @remote_node_prefix "servernode"
  @reconnect_interval 5000

  @impl true
  def init(ip) do
    Util.print_message("Initializing chat app client...")

    remote_node = "#{@remote_node_prefix}@#{ip}"

    state = %__MODULE__{
      remote_node: remote_node,
      ip: ip,
      connected: false,
      reconnect_timer: nil
    }

    send(self(), :connect)

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:send_message, _message}, _from, %{connected: false} = state) do
    {:reply, {:error, :not_connected}, state}
  end

  def handle_call({:send_message, message}, _from, %{connected: true, remote_node: remote_node} = state) do
    try do
      send({:chat_server, String.to_atom(remote_node)}, {:client_message, node(), message})
      Util.print_message("Message sent: #{inspect(message)}")
      {:reply, :ok, state}
    rescue
      error ->
        Util.print_message("Error sending message: #{inspect(error)}")
        {:reply, {:error, :send_failed}, %{state | connected: false}}
    end
  end

  def handle_call(:connection_status, _from, %{connected: connected} = state) do
    status = if connected, do: :connected, else: :disconnected
    {:reply, status, state}
  end

  @impl true
  def handle_cast(:reconnect, state) do
    send(self(), :connect)
    {:noreply, state}
  end

  @impl true
  def handle_info(:connect, %{remote_node: remote_node} = state) do
    case Node.connect(String.to_atom(remote_node)) do
      true ->
        Util.print_message("Successfully connected to #{remote_node}")
        cancel_reconnect_timer(state)
        {:noreply, %{state | connected: true, reconnect_timer: nil}}

      false ->
        Util.print_message("Failed to connect to #{remote_node}. Retrying in #{@reconnect_interval}ms...")
        timer = schedule_reconnect()
        {:noreply, %{state | connected: false, reconnect_timer: timer}}
    end
  end

  def handle_info(:reconnect_timeout, state) do
    send(self(), :connect)
    {:noreply, %{state | reconnect_timer: nil}}
  end
  @doc """
  Handles disconnections from the server.
  """
  @impl true
  def handle_info({:nodedown, node}, %{remote_node: remote_node} = state) do
    if Atom.to_string(node) == remote_node do
      Util.print_message("Connection to #{remote_node} lost. Attempting to reconnect...")
      timer = schedule_reconnect()
      {:noreply, %{state | connected: false, reconnect_timer: timer}}
    else
      {:noreply, state}
    end
  end

  def handle_info(:end, state) do
    {:stop, :normal, state}
  end

  def handle_info(msg, state) do
    Util.print_message("Received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, %{reconnect_timer: timer}) do
    cancel_reconnect_timer(%{reconnect_timer: timer})
    Util.print_message("Client shutting down: #{inspect(reason)}")
    :ok
  end

  defp schedule_reconnect do
    Process.send_after(self(), :reconnect_timeout, @reconnect_interval)
  end

  defp cancel_reconnect_timer(%{reconnect_timer: nil}), do: :ok

  defp cancel_reconnect_timer(%{reconnect_timer: timer}) do
    Process.cancel_timer(timer)
    :ok
  end
end
