defmodule ChatApp.Service.Sockets.Server.Api do
  @moduledoc """
  Public API of the server (host) socket side.
  """
  @server_name :chat_app

   @doc """
  Inicia el servidor de chat.
  """
  @spec start_link() :: GenServer.on_start()
  def start_link do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  @doc """
  Envía un mensaje a un cliente específico.
  """
  @spec send_to_client(GenServer.server(), atom(), any()) :: :ok | {:error, atom()}
  def send_to_client(server \\ @server_name, client_node, message) do
    GenServer.call(server, {:send_to_client, client_node, message})
  end

  @doc """
  Envía un mensaje a todos los clientes conectados.
  """
  @spec broadcast(GenServer.server(), any()) :: :ok
  def broadcast(server \\ @server_name, message) do
    GenServer.cast(server, {:broadcast, message})
  end

  @doc """
  Obtiene la lista de clientes conectados.
  """
  @spec get_connected_clients(GenServer.server()) :: [atom()]
  def get_connected_clients(server \\ @server_name) do
    GenServer.call(server, :get_connected_clients)
  end

  @doc """
  Detiene el servidor.
  """
  @spec stop(GenServer.server()) :: :ok
  def stop(server \\ @server_name) do
    GenServer.stop(server)
  end
end
