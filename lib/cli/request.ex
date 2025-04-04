defmodule CLI.Request do
  @moduledoc """
  Handles the users input/request from the cli.
  """



  def list_command_available_options() do
    IO.puts("""
    list command options:
    ./chat_app list users  <--- will show all the users.
    ./chat_app list rooms  <--- will show all the public chatrooms.
    """
    )
  end
end
