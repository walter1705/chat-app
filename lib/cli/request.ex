defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """
  alias ChatApp.Service.DataService
  alias CLI.Main

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
    |> list_of_maps_to_string()
    |> test()
  end

  def request_list_all_rooms() do
    # DataService
  end

  defp list_of_maps_to_string(list_of_maps) do
    list_of_maps
    |> Enum.map(fn map ->
      map
      |> Map.to_list()
      |> Enum.map(fn {_key, value} ->
        ["#{value}"]
      end)
    end)
  end
  # The header for table is
  #["ID", "USERNAME", "PASSWORD_HASH", INSERTED_AT, UPDATED_AT]

  @table_format ["ID", "USERNAME", "PASSWORD_HASH", "INSERTED_AT", "UPDATED_AT"]
  def test(list) do
    {:ok, f}=TableRex.quick_render(list, @table_format) ##DELETE TEST
    IO.puts(f)
  end
end
