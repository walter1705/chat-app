defmodule ChatApp.Service.Util do
  @moduledoc """
  This module provides utility functions for the application.
  """
  @spec print_message_terminate(String.t()) :: no_return()
  def print_message_terminate(message) do
    IO.puts(message)
    System.halt(2)
  end

  @spec print_message(String.t()) :: none()
  def print_message(message) do
    IO.puts(message)
  end
end
