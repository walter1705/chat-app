defmodule ChatApp.App.Server do
  @moduledoc """
  This module implements the external API of the server.
  We decouple some of ugly spaghetti examples and make it component like.
  """

  @doc """
  Initialize the server (unique callback made by the OTP module.)
  """
  def start_link(users) do
    GenServer.start_link(SessionImpl, users, [name: SessionImpl] )
  end


  @doc """
  Add an user to a connected list. (The list is the
  state of the server)
  """
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

  # TODO  def terminate(reason, state) do
end
