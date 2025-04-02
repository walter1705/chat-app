defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """



  def list_command_available_options() do
    IO.puts("""
    Command options:
    ./chat_app list users
    ./chat_app list rooms
    """
    )
  end
end
