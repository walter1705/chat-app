defmodule ChatApp.Service.Util do
  @moduledoc """
  This module provides utility functions for the application.
  """
  @spec print_message(String.t()) :: no_return()
  def print_message(message) do
    IO.puts(message)
    System.halt(2)
  end
end
