defmodule ChatApp.Service.Sockets.Server.Host do
  @moduledoc """
  This module provides functionality to start a TCP socket server
  and handle client connections using GenServer.

  ## Features
  - Starts a server that listens for distributed Erlang connections.
  - Handles multiple client connections concurrently.
  - State management with GenServer for better reliability.
  - Graceful handling of client connections and disconnections.

  ## Usage

  # Iniciar el servidor
  {:ok, pid} = ChatApp.Service.Sockets.Server.start_link()

  # Enviar mensaje a un cliente específico
  ChatApp.Service.Sockets.Server.send_to_client(pid, client_node, "Hola cliente!")

  # Broadcast a todos los clientes
  ChatApp.Service.Sockets.Server.broadcast(pid, "Mensaje para todos")

  """
  alias CLI.Request
  require Logger

  @service :server_node

  def init(ip) do
    Logger.info("Initializing chat app client...")

    :net_kernel.monitor_nodes(true)
    remote_node = "#{@remote_node_prefix}@#{ip}" |> String.to_atom()

    @service
    |> register()

    receive_request()
  end

  defp register(service_name) do
    Process.register(self(), service_name)
  end

  defp receive_request() do
    receive do
      _ ->
        Logger.info("Received request: Unknown")
        Request.request_for_help()
    end
  end

end
