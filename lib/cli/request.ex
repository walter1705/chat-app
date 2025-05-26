defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """
  alias ChatApp.Service.{DataService, AuthService}
  alias CLI.{Main, Formater}
  alias ChatApp.Service.Sockets.Client.LegacyWrapper
  alias ChatApp.Service.Sockets.Server.LegacyWrapper, as: ServerWrapper

  @doc """
  List the available options of the command 'list'.
  """
  @spec list_command_available_options() :: no_return()
  def list_command_available_options() do
    Main.available_list_options()
  end

  @doc """
  Request the outpout of the help commands.
  """
  @spec request_for_help() :: no_return()
  def request_for_help() do
    Main.show_help_commands()
  end

  @doc """
  Request the users
  """

  def get_users() do
    DataService.get_users()
  end

  @doc """
  Request the outpout of all the users.
  """
  @spec request_list_all_users(any()) :: no_return()
  def request_list_all_users(users) do
    users
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_user_list()
    |> Main.show_table()
  end

  @doc """
  Request therooms
  """

  def get_rooms() do
    DataService.get_public_rooms()
  end

  @doc """
  Request the output of all the available public rooms.
  """
  def request_list_all_rooms(rooms) do
    rooms
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_room_list()
    |> Main.show_table()
  end

  @doc """
    Request the creation of an user and keep it in the database.
  """
  @spec request_create_user(String.t(), String.t()) :: no_return()
  def request_create_user(username, password) do
    DataService.create_user(username, password)
  end

  @spec request_create_room(String.t(), String.t(), boolean()) :: {:ok, String.t()}  | {:error, term()}
  def request_create_room(room_name, password, is_private?) do
    DataService.create_room(room_name, password, is_private?)
  end

  @spec request_create_room(String.t(), atom()) :: {:ok, String.t()} | {:error, term()}
  def request_create_room(room_name, :default) do
    DataService.create_room(room_name, "0000", false)
  end

  @doc """
  Get a room by its
  """
  def get_room_by_name(name) do
    DataService.get_room_by_name(name)
  end

  @doc """
  Tries to log in a user and return the user.
  """
  def request_log_in(username, password) do
    AuthService.login(username, password)
  end

  @doc """
  Tries to connect a user to a remote node.
  """
  @spec try_connect_user(any(), any()) :: no_return()
  def try_connect_user(user, ip) do
    LegacyWrapper.start({ip, user})
  end

  @spec try_host(binary()) :: {:error, {:node_creation_failed, :node_not_alive}}
  @doc """
  Tries to stablish a server node.
  """
  def try_host(ip) do
    ServerWrapper.start(ip)
  end

  @doc """
  Creates and store a message
  """
  def create_message(sala, mensaje, user) do
    DataService.create_message(sala, mensaje, user)
  end

  @doc """
  creates a chatroom
  """

  def create_room(name, password, _is_private?) do
    DataService.create_room(name, password, false)
  end
end
