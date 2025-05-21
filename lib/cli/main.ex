defmodule CLI.Main do
  @moduledoc """
  Principal comunication module between the user and the app external API.



  WARNING:
  System halt (0) may be only used for pure CLI  apps watch out dev.
  """

  alias CLI.{Parser, Util}

  @spec main(any()) :: no_return()
  def main(args) do
    args
    |> Parser.parse_args()
  end

  @doc """
  Show the available commands for help.
  """
  @spec show_help_commands() :: no_return()
  def show_help_commands() do
    Util.help_commands()
    |> Util.print_message()
  end
  @doc """
  Show the available `list` command options
  """
  @spec available_list_options() :: no_return()
  def available_list_options() do
    Util.list_options()
    |> Util.print_message()
  end

  @spec show_table(any()) :: no_return()
  def show_table({:ok, table}) do
    table
    |> Util.print_message()
  end

  def show_table({:error, reason}) do
    "Error: #{reason}"
    |> Util.print_message()
  end

  @doc """
  Show the creation of a entity.
  Error or sucessfull.
  """
  @spec show_creation(any()) :: no_return()
  def show_creation(message) when is_binary(message) do
    message
    |> Util.print_message()
  end

  def show_creation(changeset) when is_struct(changeset) do
    changeset
    |> Util.handle_changeset()
  end


end
