defmodule CLI.Main do
  @moduledoc """
  Principal comunication module between the user and the app external API.

  WARNING:

  System halt (0) may be only used for pure CLI  apps watch out dev.
  """

  alias CLI.{Parser}

  def main(args) do
    args
    |> Parser.parse_args()
  end

  @doc """
  Show the available commands for help..
  """
  def show_help_commands() do
    IO.puts("""
    Type

     ./chat_app help
    or
     ./chat_app -h

     For help sucker.
    """)
    System.halt(2)
  end

  def available_list_options() do
    IO.puts("""
    list command options:
    ./chat_app list users  <--- will show all the users.
    ./chat_app list rooms  <--- will show all the public chatrooms.
    """
    )
    System.halt(2)
  end

  def show_table({:ok, table}) do
    IO.puts(table)
    System.halt(2)
  end

  def show_table({:error, reason}) do
    IO.puts("Error: #{reason}")
    System.halt(2)
  end
end
