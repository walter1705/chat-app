defmodule CLI.Util do
  @moduledoc """
  This module is for simple generic functions
  and consants
  """
  def help_commands() do
    """
    Type

     mix run -e "CLI.Main.main()" -- help
    or
     mix run -e "CLI.Main.main()" -- -h

     For help.
    """
  end

  @doc """
  Prints a message.
  """
  @spec print_message(String.t()) :: no_return()
  def print_message(message) do
    IO.puts(message)
  end

  @doc """
  Returns the message available `list` commands.
  """
  @spec list_options() :: String.t()
  def list_options() do
    """
    list command options:
    mix run -e "CLI.Main.main()" --no-halt -- host <ip>
    ^^^ To initiate a local server.

    mix run -e "CLI.Main.main()" --no-halt -- client <username> <password> <ip>
    ^^^ To initiate n connect a client.

    mix run -e "CLI.Main.main()" -- register <username> <password>
    ^^^ To register a new user.

    """
  end

  @doc """
  Handle the changeset print.
  """
  @spec handle_changeset(struct()) :: no_return()
  def handle_changeset(changeset) do
    IO.inspect(changeset.errors, label: "Error")
    System.halt(2)
  end

  @doc """
  Welcome message for succesful log in.
  """
  def welcome_message(username) do
    """
    Welcome #{username} to the chat app!
    """
  end

  @doc """
  Returns a message for wron log in from the client.
  """
  def client_log_in_help() do
    """
    WRONG USER/PASSWORD OR NON/EXISTING USER.
    Retry using again:
    ./chat_app client <username> <password>
    """
  end
end
