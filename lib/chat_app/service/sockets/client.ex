defmodule ChatApp.Service.Sockets.Client do
  @moduledoc """
  This module provides functionality to connect
  to a TCP socket server and facilitate communication.

  ## Features
  - Connects to a server on a specified host and port.
  - Sends and receives messages over a TCP connection.
  - Simple and extensible for various chat client use cases.

  ## Notes
  - Ensure the server is running and reachable before connecting.
  - Handle disconnections gracefully in the client application.
  """
  @service_name :chat_app

  alias ChatApp.Service.Util

  def main() do
    Util.print_message("Initializing host...")

    @service_name
    |> register_service()

    establish_connection(@remote_node)
    |> start_production()

    :ok
  end

  defp register_service(service_name) do
    Process.register(self(), service_name)
  end

  defp establish_connection(remote_node) do
    Node.connect(remote_node)
  end

  defp start_production(false) do
    InputData.show_error("Could not connect to the server node.")
  end

  defp start_production(true) do
    send_messages()
    receive_responses()
  end

  defp send_messages() do
    Enum.each(@messages, &send_message/1)
  end

  defp send_message(message) do
    send(@remote_service, {@local_service, message})
  end

  defp receive_responses() do
    receive do
      :end ->
        :ok

      response ->
        InputData.show_error("\t -> \"#{response}\"")
        receive_responses()

      :fin ->
        :ok

      respuesta ->
        EntradaDatos.mostrar_error("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end
