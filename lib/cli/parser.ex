defmodule CLI.Parser do
  @moduledoc """
  Parses the input/request of the user.
  """

  @doc """
  Parse the args received from the user and check if
  they are valid or not.
  Also handle most of the request of the module request.
  """
  alias CLI.Main
  alias CLI.Request

  @spec parse_args([binary()]) :: no_return()
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





  def handle_parse(["create", "--user", user_name, password]) do
    Request.request_create_user(user_name, password)
  end

  def handle_parse(["create", "--room",room_name, is_private? ,password]) do
    Request.request_create_room(room_name, password, is_private?)
  end

  def handle_parse(["create", "--room",room_name]) do
    Request.request_create_room(room_name, :default)
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
  @moduledoc """
  Handle the creation of an entity.
  """
  def handle_creation({:ok, user}) do
    """
     User #{user.username} created.
    """
    |> Main.show_creation()
  end

  def handle_creation({:error, changeset}) do
    changeset
    |> Main.show_creation()
  end

end
