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

  def request_list_all_users() do
    DataService.get_users()
    |> Formater.list_of_maps_to_list_of_list()
    |> Formater.format_user_list()
    |> Main.show_table()
  end

  def request_list_all_rooms() do
    # DataService
  end
end
