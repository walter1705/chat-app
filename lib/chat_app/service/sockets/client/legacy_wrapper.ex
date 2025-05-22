defmodule ChatApp.Service.Sockets.Client.LegacyWrapper do
 @moduledoc """
  Wrapper que maneja la creación del nodo distribuido y el ciclo de vida del cliente.

  Este módulo se encarga de:
  - Crear el nodo distribuido si es necesario
  - Iniciar el GenServer cliente
  - Proporcionar una API de conveniencia
  - Mantener compatibilidad con la API original

  ## Uso
  # Start client with automatic node creation
  {:ok, pid} = ChatApp.Service.Sockets.ClientWrapper.start_link("192.168.1.100")

  # Start client with automatic node creation
  #with personalized options
  {:ok, pid} = ChatApp.Service.Sockets.ClientWrapper.start_link("192.168.1.100", [
    node_name: "mi_cliente@192.168.1.100",
    name_type: :longnames,
    create_node: true
  ])

  # API
  ChatApp.Service.Sockets.ClientWrapper.main("192.168.1.100")
  ```
  """

  alias ChatApp.Service.Sockets.Client.{Api, Server}
  alias ChatApp.Service.Util

  @type node_opts :: [
    node_name: String.t(),
    name_type: :shortnames | :longnames,
    create_node: boolean()
  ]

  @doc """
  Inicia el cliente con creación automática de nodo
  """
  @spec start_link(String.t(), node_opts()) :: GenServer.on_start()
  def start_link(ip, opts \\ []) do
    case ensure_node(ip, opts) do
      :ok ->
        Api.start_link(ip)
      {:error, reason} ->
        {:error, {:node_creation_failed, reason}}
    end
  end

  @doc """
  Inicia el cliente sin link
  """
  @spec start(String.t(), node_opts()) :: GenServer.on_start()
  def start(ip, opts \\ []) do
    case ensure_node(ip, opts) do
      :ok ->
        Client.start(ip)
      {:error, reason} ->
        {:error, {:node_creation_failed, reason}}
    end
  end

  @doc """
  Función main compatible con la API original
  """
  @spec main(String.t(), node_opts()) :: :ok
  def main(ip, opts \\ []) do
    case start_link(ip, opts) do
      {:ok, _pid} ->
        Util.print_message("Client started successfully. Waiting for :end message...")
        # Mantener el proceso principal vivo hasta recibir :end
        receive do
          :end ->
            Util.print_message("Received :end signal, shutting down...")
            Client.stop(:chat_app)
            :ok
        end
      {:error, reason} ->
        Util.print_message("Failed to start client: #{inspect(reason)}")
        :error
    end
  end

  @spec ensure_node(String.t(), node_opts()) :: :ok | {:error, term()}
  defp ensure_node(ip, opts) do
    create_node = Keyword.get(opts, :create_node, true)

    case Node.alive?() do
      true ->
        Util.print_message("Node already running: #{Node.self()}")
        :ok
      false when create_node ->
        create_distributed_node(ip, opts)
      false ->
        Util.print_message("Node creation disabled and no node running")
        {:error, :node_not_alive}
    end
  end

  @spec create_distributed_node(String.t(), node_opts()) :: :ok | {:error, term()}
  defp create_distributed_node(ip, opts) do
    node_name = Keyword.get(opts, :node_name, "cliente_chat@#{ip}")
    name_type = Keyword.get(opts, :name_type, :shortnames)

    Util.print_message("Creating distributed node: #{node_name}")

    case Node.start(String.to_atom(node_name), name_type) do
      {:ok, _} ->
        Util.print_message("Node created successfully: #{node_name}")
        :ok
      {:error, reason} ->
        Util.print_message("Failed to create node with #{name_type}: #{inspect(reason)}")

        alternate_type = if name_type == :shortnames, do: :longnames, else: :shortnames
        Util.print_message("Trying with #{alternate_type}...")

        case Node.start(String.to_atom(node_name), alternate_type) do
          {:ok, _} ->
            Util.print_message("Node created with #{alternate_type}: #{node_name}")
            :ok
          {:error, reason} ->
            Util.print_message("Failed to create node with #{alternate_type}: #{inspect(reason)}")
            {:error, reason}
        end
    end
  end
end
