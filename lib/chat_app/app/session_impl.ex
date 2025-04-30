defmodule ChatApp.App.SessionImpl do
  @moduledoc """
    This is the internal API of the module that keep
    track the usser in-session.
  """

  use GenServer

  @doc """
  GenServer implementation of the function 'init()'.

    Example:
    iex> init(users_online)
    {:ok, users_online}
  """

  @impl true
  def init(users_online) do
    {:ok, users_online}
  end

  @impl true
  def handle_call({:add_user, user}, _from, users_onsession) do
    new_users = List.insert_at(users_onsession, -1, user)
    {:reply, user, new_users}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
