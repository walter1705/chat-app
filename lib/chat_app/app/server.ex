defmodule ChatApp.App.Server do
  @moduledoc """
  This module implements the logic of the server.
  We decouple some of ugly spaghetti examples and make it component like.
  """
  use GenServer


  @doc """
  Implementation of the behaviour GenServer.
  'init()' receives the arguments of the initial state of a Server.
  """

  def init(state \\ []) do
    {:ok, state}
  end

end
