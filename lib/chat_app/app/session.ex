defmodule ChatApp.App.Session do
  @moduledoc """
  This is the external API of the module that keep
  track the usser in-session.
  """
  alias ChatApp.App.SessionImpl

  def start_link(users) do
    GenServer.start_link(SessionImpl, users, [name: SessionImpl] )
  end

  def add_user_to_session(user) do
    GenServer.call(SessionImpl, {:add_user, user})
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
