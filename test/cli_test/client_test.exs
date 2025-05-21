defmodule CLITest.ClientTest do
  use ExUnit.Case


  test "Request commands form user right" do
    requested = "list users"
      |> String.trim()
      |> String.split(" ")

    assert(requested == ["list", "users"])
  end
end
