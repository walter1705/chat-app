defmodule ChatApp.Service.Sockets.Server.Host do
  @moduledoc """
  Este módulo implementa el servidor del sistema de chat y manejo de trabajos.
  """

  alias DB.Schemas.Message
  alias CLI.Request
  alias DB.Schemas.ChatRoom
  require Logger

  @nombre_servicio :server_node

  def start() do
    spawn_link(__MODULE__, :init, [])
  end

  def init() do
    Logger.info("Servidor iniciado...")
    registrar_servicio(@nombre_servicio)
    procesar_mensajes()
  end

  defp registrar_servicio(nombre) do
    Process.register(self(), nombre)
    :net_kernel.monitor_nodes(true)
  end

  defp procesar_mensajes(nodes \\ []) do
    receive do
      {:connect_room, name, cliente} ->
        case Request.get_room_by_name(name) do
          %ChatRoom{} = sala ->
            send(cliente, {:ok, sala})
            new_nodes = [{cliente, sala} | nodes]
            procesar_mensajes(new_nodes)
          _ ->
            send(cliente, {:error, :not_found})
            procesar_mensajes(nodes)
        end
      {:send_message, sender, mensaje, sala, user} ->
        broadcast(sala, mensaje, user, sender, nodes)
        procesar_mensajes(nodes)

      {:create_room, sender, name} ->
        case Request.create_room(name, "password", false) do
          {:ok, sala} ->
            send(sender, {:ok, sala})
          {:error, changeset} ->
            send(sender, {:error, changeset.errors})
          _ ->
            send(sender, {:error, :unknown})
          end
        procesar_mensajes()
      {:get_users, sender} ->
        users = Request.get_users()
        send(sender, {:ok, users})
        procesar_mensajes()
      {:get_rooms, sender} ->
        rooms = Request.get_rooms()
        send(sender, {:ok, rooms})
        procesar_mensajes(nodes)
      {:end, cliente} ->
        Logger.info("Cliente #{inspect(cliente)} desconectado.")
        send(cliente, :end)
        procesar_mensajes(nodes)

      _ ->
        Logger.info("Mensaje desconocido recibido.")
        procesar_mensajes(nodes)
    end
  end

  defp broadcast(sala, mensaje, user_sender, _pid, nodes) do
    mensaje_valid = store_message_sala(sala, mensaje, user_sender)
    case mensaje_valid do
      %Message{}=message ->
        nodes |> Enum.each(fn {node, sala1}
        when sala.id == sala1.id -> send(node, {:message, message}) end)
      {:error, _} -> Logger.error("Error al crear el mensaje")
    end
  end

  defp store_message_sala(sala, mensaje, user) do
   case Request.create_message(sala, mensaje, user) do
     {:ok, message} -> message
     {:error, changeset} -> changeset.errors
   end
  end
end
