defmodule CLI.Client do
  @moduledoc """
  Handles the request made by an user inputs.
  """
  alias CLI.Request

  @doc """
  Request a command from the user.
  """
  def listen_for_commands do
    IO.puts("Enter a command:")
    input = IO.gets("") |> String.trim() |> String.split(" ")
    handle_parse(input)
  end


  @doc """
  Handles the commands.
  Example:
    iex> handle_parse(['help'])
    Available commands: ... ... ...

    iex> handle_parse(:action)
    {:ok, reply}

    iex> handle_parse(["uknown"])
    :invalid
  """
  @spec handle_parse([String.t()]) :: {atom()} | {atom(), String.t()}
  def handle_parse(["list", "rooms"]) do
    Request.request_list_all_rooms()
    listen_for_commands()
  end

  def handle_parse(["list", "users"]) do
    Request.request_list_all_users()
    listen_for_commands()
  end

  def handle_parse(["list"]) do
    Request.list_command_available_options()
    listen_for_commands()
  end

  def handle_parse(["list", _]) do
    Request.list_command_available_options()
    listen_for_commands()
  end

  def handle_parse(["create", "--user", user_name, password]) do
    Request.request_create_user(user_name, password)
    listen_for_commands()
  end

  def handle_parse(["create", "--room",room_name, is_private? ,password]) do
    Request.request_create_room(room_name, password, is_private?)
    listen_for_commands()
  end

  def handle_parse(["create", "--room",room_name]) do
    Request.request_create_room(room_name, :default)
    listen_for_commands()
  end

  def handle_parse(["join", room_name]) do
    Request.request_join_room(room_name)
    listen_for_commands()
  end

  def handle_parse(["--help"]) do
    Request.request_for_help()
  end

  def handle_parse(["-h"]) do
    Request.request_for_help()
  end

  def handle_parse(_) do
    Request.request_for_help()
  end
end
