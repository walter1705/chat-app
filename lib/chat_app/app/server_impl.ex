defmodule ChatApp.App.ServerImpl do
  use GenServer
  @moduledoc """
  This module implements the itnernal implementation of the server.
  """

  @doc """
  Implementation of the behaviour GenServer.
  'init()' receives the arguments of the initial state of a Server.
  """

  def init(state) do
    {:ok, state}
  end

  def handle_call(:list_rooms, _from, state) do
    {:reply, :ok, state}
  end

  def handle_call(:list_users, _from, state) do
    {:reply, :ok, state}
  end

  def handle_call({:create_room, room_name}, _from, state) do
    {:reply, :ok, state}
  end

  def handle_call({:join, room_name}, _from, state) do
    {:reply, :ok, state}
  end
end
