defmodule ChatApp.Service.Sockets.Server.LegacyWrapper do
  alias ChatApp.Service.Sockets.Server.Host
  alias ChatApp.Service.Util

  @type node_opts :: [
          node_name: String.t(),
          name_type: :longnames,
          create_node: boolean()
        ]

  @doc """
  Inicia el servidor con creación automática de nodo.
  """
  @spec start(String.t(), node_opts()) :: :ok | {:error, term()}
  def start(ip, opts \\ []) do
    case ensure_node(ip, opts) do
      :ok ->
        Host.start()

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

  @spec create_distributed_node(String.t(), node_opts()) :: :ok | {:error, term()}
  defp create_distributed_node(ip, _opts) do
    node_name = "server_node@#{ip}"
    name_type = :longnames
    cookie = Util.get_cookie()

    Util.print_message("Creating distributed node: #{node_name}")

    case Node.start(String.to_atom(node_name), name_type) do
      {:ok, _} ->
        Node.set_cookie(cookie)
        Util.print_message("Node created successfully: #{node_name}")
        :ok
      {:error, reason} ->
        Util.print_message("Failed to create node with #{name_type}: #{inspect(reason)}")
    end
  end
end
