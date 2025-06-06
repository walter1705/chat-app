defmodule CLI.Formater do
  @moduledoc """
  This module formats the output of the app.
  """
  @room_table_format ["ID", "ROOM_NAME", "PASSWORD_HASH", "IS_PRIVATE?", "INSERTED_AT", "UPDATED_AT"]
  @user_table_format ["ID", "USERNAME", "PASSWORD_HASH", "INSERTED_AT", "UPDATED_AT"]
  @spec format_user_list([list()]) :: {atom(), binary()}

  @spec format_user_list(list()) :: binary()
  def format_user_list(list) do
    TableRex.quick_render(list, @user_table_format)
  end

  @spec format_room_list([list()]) :: {atom(), binary()}
  def format_room_list(list) do
    TableRex.quick_render(list, @room_table_format)
  end

  @spec list_of_maps_to_list_of_list(any()) :: list()
  def list_of_maps_to_list_of_list(list_of_maps) do
    list_of_maps
    |> Enum.map(fn map ->
      map
      |> Map.to_list()
      |> Enum.map(fn {_key, value} ->
        ["#{value}"]
      end)
    end)
  end
end
