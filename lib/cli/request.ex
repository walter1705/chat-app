defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """
  alias ChatApp.Service.DataService
  alias CLI.{Main, Formater}

  @doc """
  List the available options of the command 'list'.
  """
  def list_command_available_options() do
    Main.available_list_options()
  end

  def request_for_help() do
    Main.show_help_commands()
  end

  @spec request_list_all_users() :: no_return()
  def request_list_all_users() do
    DataService.get_users()
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_user_list()
    |> Main.show_table()
  end

  def request_list_all_rooms() do
    DataService.get_rooms()
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_room_list()
    |> Main.show_table()
  end

  @spec request_create_user(String.t(), String.t()) :: {:ok, String.t()}  | {:error, term()}
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

  @spec request_join_room(String.t()) :: :ok | {:error, term()}
  def request_join_room(room_name) do
    #DataService.join_room(room_name)
  end

  @spec request_leave_room(String.t()) :: :ok | {:error, term()}
  def request_leave_room(room_name) do
    #DataService.leave_room(room_name)
  end

end
