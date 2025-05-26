defmodule ChatApp.Service.Sockets.Client.Cliente do
  @moduledoc """
  This module replaces the GenServer for handling client connections
  and communication with a remote node in a simpler process-based approach.
  """
  alias ElixirSense.Log
  alias CLI.Request
  alias DB.Schemas.{ChatRoom, ChatRoomUser, Message}
  alias CLI.Util

  require Logger

  @remote_node_prefix "server_node"
  @service :server_node
  @local_service :client_node

  @doc """
  Starts the client node process.
  """
  def start(ip, user) do
    spawn_link(__MODULE__, :init, [ip, user])
  end

  @spec init(any(), any()) :: no_return()
  def init(ip, user) do
    Logger.info("Initializing chat app client...")

    :net_kernel.monitor_nodes(true)
    remote_node = "#{@remote_node_prefix}@#{ip}" |> String.to_atom()

    @local_service
    |> register()

    connect(remote_node)
    |> IO.inspect()
    |> initialize_app()

    menu({@service, remote_node}, user)
  end

  defp register(service_name) do
    Process.register(self(), service_name)
  end

  defp connect(node) do
    Logger.info("Attempting to connect to #{node}...")
    Node.connect(node)
  end

  @spec initialize_app(true) :: :ok
  def initialize_app(true) do
    Util.print_message("Connected to #{node()}")
  end

  @spec initialize_app(false) :: no_return
  def initialize_app(false) do
    Util.print_message("Failed to connect to #{node()}")
    System.halt(0)
  end

  def menu(service, user) do
    IO.puts("\nOpciones:")
    IO.puts("1. Entrar a sala.")
    IO.puts("2. Crear sala de chat")
    IO.puts("3. Consultar usuarios.")
    IO.puts("4. Consultar salas.")
    IO.puts("99. Salir")
    IO.write("> ")

    case IO.gets("") |> String.trim() |> String.to_integer() do
      1 -> conectar_sala(service, user)
      2 -> crear_sala(service, user)
      3 -> consultar_usuarios(service, user)
      4 -> consultar_salas(service, user)
      99 -> end_app(service)
      _ -> IO.puts("Opción no válida.")
    end

    menu(service, user)
  end

  defp consultar_salas(servicio, user) do
    send(servicio, {:get_rooms, self()})
    receive do
      {:ok, rooms} ->
        Request.request_list_all_rooms(rooms)
        menu(servicio, user)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        menu(servicio, user)
    end
  end

  defp consultar_usuarios(servicio, user) do
    send(servicio, {:get_users, self()})
    receive do
      {:ok, users} ->
        Request.request_list_all_users(users)
        menu(servicio, user)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        menu(servicio, user)
    end
  end

  defp crear_sala(servicio, user) do
    IO.write("Ingrese el nombre de la sala: ")
    name = IO.gets("") |> String.trim()

    send(servicio, {:create_room, self(), name})

    receive do
      {:ok, %ChatRoom{} = chatroom} ->
        IO.puts("Sala \"#{chatroom.name}\" creada.")
        menu(servicio, user)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        menu(servicio, user)
      {:error, :unknown} ->
        IO.puts("Error: No se recibió respuesta del servidor.")
        menu(servicio, user)
      after
        5000 -> IO.puts("Error: No se recibió respuesta del servidor.")
      end
  end

  defp conectar_sala(servicio, user) do
    IO.write("Ingrese el nombre de la sala: ")
    name = IO.gets("") |> String.trim()

    send(servicio, {:connect_room, name, self()})

    receive do
      {:ok, %ChatRoom{} = chatroom} ->
        IO.puts("Conectado a la sala \"#{chatroom.name}\". escriba EXIT para salir.")
        chat(chatroom, servicio, chatroom, user)
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        menu(servicio, user)
    after
      5000 -> IO.puts("Error: No se recibió respuesta del servidor.")
    end
  end

  defp chat(chatroom, service, sala, user, history \\ []) do
    IO.write("> ")
    message = IO.gets("") |> String.trim()

    if String.upcase(message) == "EXIT" do
      Logger.info("Desconectado de la sala: #{sala.name}")
      menu(service, user)
    else
      send(service, {:send_message, self(), message, sala, user})

      receive do
        {:message, %Message{} = msg} ->
          updated_history = [{msg.user_id, msg.content} | history]

          Enum.each(Enum.reverse(updated_history), fn {from, content} ->
            IO.puts("#{from}: #{content}")
          end)

          chat(chatroom, service, sala,user, updated_history)

        {:error, reason} ->
          IO.puts("Error: #{reason}")
      end
    end
  end

  @spec end_app(any()) :: no_return()
  def end_app(service) do
    send(service, {:end, self()})

    receive do
      :end -> IO.puts("Desconectado del servidor.")
    after
      5000 -> IO.puts("Error: No se recibió respuesta del servidor.")
    end

    System.halt(0)
  end
end
