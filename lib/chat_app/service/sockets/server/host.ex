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

  defstruct [
    :connected_clients,
    :server_name
  ]

  use GenServer

  alias ChatApp.Service.Sockets.Client.Server
  alias ChatApp.Service.Util

  @server_name :chat_server




  @impl true
  def init([]) do
    Util.print_message("Starting chat server...")

    # Registrar el proceso con el nombre del servidor
    Process.register(self(), @server_name)

    # Monitorear nodos para detectar desconexiones
    :net_kernel.monitor_nodes(true)

    state = %__MODULE__{
      connected_clients: MapSet.new(),
      server_name: @server_name
    }

    Util.print_message("Chat server started successfully on node: #{node()}")

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:send_to_client, client_node, message}, _from, state) do
    if MapSet.member?(state.connected_clients, client_node) do
      try do
        send({:client_process, client_node}, {:server_message, message})
        Util.print_message("Message sent to #{client_node}: #{inspect(message)}")
        {:reply, :ok, state}
      rescue
        error ->
          Util.print_message("Error sending message to #{client_node}: #{inspect(error)}")
          # Remover cliente desconectado
          new_clients = MapSet.delete(state.connected_clients, client_node)
          {:reply, {:error, :send_failed}, %{state | connected_clients: new_clients}}
      end
    else
      {:reply, {:error, :client_not_connected}, state}
    end
  end

  def handle_call(:get_connected_clients, _from, state) do
    clients = MapSet.to_list(state.connected_clients)
    {:reply, clients, state}
  end

  @impl true
  def handle_cast({:broadcast, message}, state) do
    Util.print_message("Broadcasting message to all clients: #{inspect(message)}")

    # Enviar mensaje a todos los clientes conectados
    active_clients =
      state.connected_clients
      |> Enum.filter(fn client_node ->
        try do
          send({:client_process, client_node}, {:server_message, message})
          true
        rescue
          _error ->
            Util.print_message("Failed to send to #{client_node}, removing from active clients")
            false
        end
      end)
      |> MapSet.new()

    {:noreply, %{state | connected_clients: active_clients}}
  end

  @impl true
  def handle_info({:client_message, client_node, message}, state) do
    Util.print_message("Received from #{client_node}: #{inspect(message)}")

    # Agregar cliente a la lista de conectados si no está
    new_clients = MapSet.put(state.connected_clients, client_node)

    # Aquí puedes procesar el mensaje y responder si es necesario
    # Por ejemplo, hacer echo del mensaje de vuelta al cliente:
    response = "Echo: #{message}"
    send({:client_process, client_node}, {:server_message, response})

    {:noreply, %{state | connected_clients: new_clients}}
  end

  def handle_info({:nodeup, node}, state) do
    Util.print_message("Node connected: #{node}")
    {:noreply, state}
  end

  def handle_info({:nodedown, node}, state) do
    Util.print_message("Node disconnected: #{node}")
    # Remover el nodo de la lista de clientes conectados
    new_clients = MapSet.delete(state.connected_clients, node)
    {:noreply, %{state | connected_clients: new_clients}}
  end

  def handle_info(:end, state) do
    {:stop, :normal, state}
  end

  def handle_info(msg, state) do
    Util.print_message("Received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    Util.print_message("Server shutting down: #{inspect(reason)}")
    :ok
  end
end
