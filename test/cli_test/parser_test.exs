defmodule CLITest.ParserTest do
  use ExUnit.Case
  alias CLI.{Parser, Request}

  @doc """
  handle_arg/ unit tests of the function
  """

  test "['list', 'rooms'] returns {:list_rooms}" do
    assert(Parser.handle_parse(["list", "rooms"]) == {:list_rooms})
  end


  test "['list', 'users'] returns {:list_users}" do
    assert(Parser.handle_parse(["list", "users"]) == {:list_users})
  end

  test "['list', '?'] or [list] returns the available commands of list" do
    assert(
      Parser.handle_parse(["list", "all"]) ==
        Request.list_command_available_options()
    )
    assert(Parser.handle_parse(["list"])) ==
      Request.list_command_available_options()

  end

  test "['create' room_name] returns {}" do
    assert(Parser.handle_parse(["create", "trading"]) == {:create_room, "trading"})
  end

  test "['join' room_name] returns {}" do
    assert(Parser.handle_parse(["join", "trading"]) == {:join, "trading"})
  end

  test "'[--help]' or '[-h]' string returns :help atom in handle_args/1" do
    assert(Parser.handle_parse(["--help"]) == :help)
    assert(Parser.handle_parse(["-h"]) == :help)
  end

  test "unknown or incorrect command (example: with uppercase) return :invalid" do
    assert(Parser.handle_parse(["ayuda"]) == :invalid)
    assert(Parser.handle_parse(["--Help"]) == :invalid)
  end
end
