defmodule ChatApp.Service.Sockets.Client.Api do
  @moduledoc """
  Public API for the client socket side using a plain process instead of GenServer.
  """

  alias ChatApp.Service.Sockets.Client.Server

  @doc """
  Starts the client process linked to the current process.
  """
  @spec start_link(String.t()) :: pid()
  def start_link(ip) do
    Server.start(ip)
  end

  @doc """
  Sends a message to the remote server process.

  Returns :ok immediately; the client logs errors internally.
  """
  @spec send_message(pid(), any()) :: :ok
  def send_message(client_pid, message) when is_pid(client_pid) do
    send(client_pid, {:send_message, message})
    :ok
  end

  @doc """
  Requests the connection status from the client process.

  This example assumes the client process would need to be extended
  to support status requests and replies.
  """
  @spec connection_status(pid()) :: :connected | :disconnected | :unknown
  def connection_status(client_pid) when is_pid(client_pid) do
    ref = make_ref()
    send(client_pid, {:get_status, self(), ref})

    receive do
      {:status_response, ^ref, status} -> status
    after
      2000 -> :unknown
    end
  end

  @doc """
  Forces the client process to reconnect immediately.
  """
  @spec reconnect(pid()) :: :ok
  def reconnect(client_pid) when is_pid(client_pid) do
    send(client_pid, :reconnect)
    :ok
  end

  @doc """
  Stops the client process gracefully.
  """
  @spec stop(pid()) :: :ok
  def stop(client_pid) when is_pid(client_pid) do
    send(client_pid, :shutdown)
    :ok
  end
end
