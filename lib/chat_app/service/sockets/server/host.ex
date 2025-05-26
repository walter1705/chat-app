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

  defp procesar_mensajes() do
    receive do
      {:connect_room, name, cliente} ->
        case Request.get_room_by_name(name) do
          %ChatRoom{} = sala ->
            send(cliente, {:ok, sala})
          _ ->
            send(cliente, {:error, :not_found})
        end
      {:send_message, sender, mensaje, sala, user} ->
        broadcast(sala, mensaje, user, sender)
        procesar_mensajes()
      {:end, cliente} ->
        Logger.info("Cliente #{inspect(cliente)} desconectado.")
        send(cliente, :end)
        procesar_mensajes()

      _ ->
        Logger.info("Mensaje desconocido recibido.")
        procesar_mensajes()
    end
  end

  defp broadcast(sala, mensaje, user_sender, pid) do
    mensaje_valid = store_message_sala(sala, mensaje, user_sender)
    case mensaje_valid do
      %Message{}=message -> send(pid, {:message, message})
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
