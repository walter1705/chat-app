defmodule ChatApp.Service.Sockets.Client.Api do
  @moduledoc """
  Public API of the client socket side.
  """

  alias ChatApp.Service.Sockets.Client.Server



  @doc """
  Initialize the client.
  """
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(ip) do
    GenServer.start_link(Server, ip, name: @service_name)
  end

  @doc """
  Envía un mensaje al servidor remoto
  """
  @spec send_message(GenServer.server(), any()) :: :ok | {:error, :not_connected}
  def send_message(server, message) do
    GenServer.call(server, {:send_message, message})
  end

  @doc """
  Obtiene el estado completo del cliente
  """
  @spec get_state() :: map()
  def get_state() do
    GenServer.call(Server, :get_state)
  end

  @doc """
  Get the connected status.
  """
  @spec connection_status() :: :connected | :disconnected
  def connection_status() do
    GenServer.call(Server, :connection_status)
  end

  @doc """
  Forces a connection.
  """
  @spec reconnect() :: :ok
  def reconnect() do
    GenServer.cast(Server, :reconnect)
  end

  @doc """
  Stops the client gracefully.
  """
  @spec stop() :: :ok
  def stop() do
    GenServer.stop(Server, :normal)
  end

  @doc """
  This function manually put the settings that the OTP application
  requires to work in the supervision tree.
  """
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
