defmodule ChatApp.Service.Util do
  @moduledoc """
  This module provides utility functions for the application.
  """
  @cookie_path "sockets/cookie"

  @spec print_message_terminate(String.t()) :: no_return()
  def print_message_terminate(message) do
    IO.puts(message)
    System.halt(2)
  end

  @spec print_message(any()) :: :ok
  def print_message(message) do
    IO.puts(message)
    :ok
  end

  @doc """
  Gets the cookie from the file content.
  """
  @spec get_cookie() :: atom()
  def get_cookie() do
    File.read(@cookie_path)
    |> handle_read()
  end

  def handle_read({:ok, content}) do
    content
    |> String.trim()
    |> String.to_atom()
  end

  @spec handle_write(any()) :: no_return()
  def handle_write({:error, reason}) do
    print_message_terminate("Failed to write cookie: #{inspect(reason)}")
  end
end
