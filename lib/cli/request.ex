defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """
  alias ChatApp.Service.{DataService, AuthService}
  alias CLI.{Main, Formater, Parser}
  alias ChatApp.Service.Sockets.Client.LegacyWrapper

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
  Request the outpout of all the users.
  """
  @spec request_list_all_users() :: no_return()
  def request_list_all_users() do
    DataService.get_users()
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_user_list()
    |> Main.show_table()
  end

  @doc """
  Request the output of all the available public rooms.
  """
  def request_list_all_rooms() do
    DataService.get_public_rooms()
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
  #for the
  @spec request_join_room(String.t()) :: {:ok, term()} | {:error, term()}
  def request_join_room(room_name) do
    #DataService.join_room(room_name)
  end

  @spec request_leave_room(String.t()) :: {:ok, term()} | {:error, term()}
  def request_leave_room(room_name) do
    #DataService.leave_room(room_name)
  end

  def request_log_in(username, password) do
    AuthService.login(username, password)
  end

  def try_connect_user(_user, ip) do
    LegacyWrapper.start_link(ip)
  end
end
