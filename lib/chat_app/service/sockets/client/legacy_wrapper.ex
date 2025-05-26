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

  alias ChatApp.Service.Sockets.Client.{Cliente}
  alias ChatApp.Service.Util

  @type node_opts :: [
          node_name: String.t(),
          name_type: :shortnames | :longnames,
          create_node: boolean()
        ]

  @doc """
  Inicia el cliente con creación automática de nodo
  """
  @spec start({String.t(), String.t()}, node_opts()) :: :ok | {:error, term()}
  def start({ip, user}, opts \\ []) do
    case ensure_node(ip, opts) do
      :ok ->
        Cliente.start(ip, user)

      {:error, reason} ->
        {:error, {:node_creation_failed, reason}}
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

  @spec create_distributed_node(String.t(), keyword()) :: :ok | {:error, term()}
  defp create_distributed_node(ip, _opts) do
    node_name = "cliente_chat@#{ip}"
    name_type = :longnames
    cookie = Util.get_cookie()

    Util.print_message("Creating distributed node: #{node_name}")

    case Node.start(String.to_atom(node_name), name_type) do
      {:ok, _pid} ->
        Node.set_cookie(cookie)
        Util.print_message("Node created successfully: #{node_name}")
        :ok
      {:error, reason} ->
        Util.print_message("Failed to create node with #{name_type}: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
