defmodule CLI.Parser do
  @moduledoc """
  Parses the input/request of the user.
  """

  @doc """
  Parse the args received from the user and check if
  they are valid or not.
  """
  alias CLI.Request

  @spec parse_args([binary()]) :: atom()
  def parse_args(args) do
    OptionParser.parse(args,
      switches: [help: :boolean],
      alias: [h: :help]
    )
    |> elem(1)
    |> handle_parse()
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
    #{:list_rooms}
  end


  def handle_parse(["list", "users"]) do
    Request.request_list_all_users()
  end

  def handle_parse(["list"]) do
    Request.list_command_available_options()
  end


  def handle_parse(["list", _]) do
    Request.list_command_available_options()
  end







  def handle_parse(["create", room_name]) do
    {:create_room, room_name}
  end


  def handle_parse(["join", room_name]) do
    {:join, room_name}
  end


  def handle_parse(["--help"]) do
    :help
  end


  def handle_parse(["-h"]) do
    :help
  end

  def handle_parse(_) do
    Request.request_for_help()
  end



  # def handle_parse(arg) do
  # TODO ACTIONS COMMAND NEED TO HAVE THEIR OWN CLAUSE
  # end
end
