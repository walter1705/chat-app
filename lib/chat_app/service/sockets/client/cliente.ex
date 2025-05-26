defmodule ChatApp.Service.Sockets.Client.Cliente do
  @moduledoc """
  This module replaces the GenServer for handling client connections
  and communication with a remote node in a simpler process-based approach.
  """
  alias DB.Schemas.ChatRoom
  alias CLI.Util

  require Logger

  @remote_node_prefix "server_node"
  @service :server_node
  @local_service :client_node

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

    @local_service
      |> register()

    connect(remote_node)
      |> initialize_app(remote_node)
  end

  defp register(service_name) do
    Process.register(self(), service_name)
  end

  defp connect(node) do
    Logger.info("Attempting to connect to #{node}...")
    Node.connect(node)
  end

  def initialize_app(true, server_node) do
    Util.print_message("Connected to #{node()}")
    menu({@service, server_node})
  end

  def initialize_app(false, _server_node) do
    Util.print_message("Failed to connect to #{node()}")
  end

  defp menu(service) do
    IO.puts("\nOpciones:")
    IO.puts("1. Entrar a sala. ()")
    IO.puts("2. Consultar autores de un trabajo")
    IO.puts("99. Salir")
    IO.write("> ")

    case IO.gets("") |> String.trim() |> String.to_integer() do
      1 -> conectar_sala(service)
      99 -> end_app(service)
      _ -> IO.puts("Opción no válida.")
    end

    menu(service)
  end

  defp conectar_sala(servicio) do
    IO.write("Ingrese el nombre de la sala: ")
    name = IO.gets("")

    send(servicio, {:connect_room, name, self()})

    receive do
      {:ok, %ChatRoom{} = chatroom} ->
        IO.puts("Conectado a la sala \"#{chatroom.name}\. escriba EXIT para salir.")
        chat(chatroom, servicio, chatroom)
    after
      5000 -> IO.puts("Error: No se recibió respuesta del servidor.")
    end
  end

  defp chat(chatroom, service, sala) do
    IO.write("> ")
    message = IO.gets("") |> String.trim()

    if String.upcase(message) == "EXIT" do
      menu({@service, chatroom.server_node})
    else
      send(service, {:send_message, self(), message, sala})

      receive do
        {:message, msg} ->
          IO.puts("#{msg.from}: #{msg.content}")
          chat(chatroom, service, sala)

        {:error, reason} ->
          IO.puts("Error: #{reason}")
      end
    end
  end

  defp end_app(service) do
    send(service, {:end, self()})

    receive do
      :end -> IO.puts("Desconectado del servidor.")
    after
      5000 -> IO.puts("Error: No se recibió respuesta del servidor.")
    end

    System.halt(0)
  end
end
