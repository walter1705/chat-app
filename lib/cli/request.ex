defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """


  @doc """
  Lis the available options of the command 'list'.
  """
  def list_command_available_options() do
    IO.puts("""
    list command options:
    ./chat_app list users  <--- will show all the users.
    ./chat_app list rooms  <--- will show all the public chatrooms.
    """
    )
  end

  def request_for_help() do
    IO.puts("""
    Type

     ./chat_app help
    or
     ./chat_app -h

     For help sucker.
    """)
  end
end
