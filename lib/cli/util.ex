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
    ./chat_app list users  <--- will show all the users.
    ./chat_app list rooms  <--- will show all the public chatrooms.
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
end
