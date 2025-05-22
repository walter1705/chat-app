defmodule CLI.Util do
  @moduledoc """
  This module is for simple generic functions
  and consants
  """
  def help_commands() do
    """
    Type

     ./chat_app help
    or
     ./chat_app -h

     For help sucker.
    """
  end

  @doc """
  Prints a message.
  """
  @spec print_message(String.t()) :: no_return()
  def print_message(message) do
    IO.puts(message)
    System.halt(2)
  end

  @doc """
  Returns the message available `list` commands.
  """
  @spec list_options() :: String.t()
  def list_options() do
    """
    list command options:
    ./chat_app host <ip> <-- To initiate a local server.
    ./chat_app client <username> <password> <ip> <-- To initiate n connect a client.
    ./chat_app register <username> <password> <-- To register a new user.





    ./chat_app list users  <-- will show all the users.
    ./chat_app list rooms  <-- will show all the public chatrooms.

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
