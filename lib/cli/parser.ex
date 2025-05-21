defmodule CLI.Parser do
  @moduledoc """
  Parses the input/request of the user.
  """

  @doc """
  Parse the args received from the user and check if
  they are valid or not.
  Also handle most of the request of the module request.
  """
  alias CLI.Main
  alias CLI.Request

  @spec parse_args([binary()]) :: no_return()
  def parse_args(args) do
    OptionParser.parse(args,
      switches: [help: :boolean],
      alias: [h: :help]
    )
    |> elem(1)
    |> handle_parse()
  end


   def handle_parse(["client"]) do
    Request.request_list_all_users()
  end

   def handle_parse(["host"]) do
    Request.request_list_all_users()
  end

  # def handle_parse(arg) do
  # TODO ACTIONS COMMAND NEED TO HAVE THEIR OWN CLAUSE
  # end
  @doc """
  Handle the creation of an entity.
  """
  @spec handle_creation(any()) :: no_return()
  def handle_creation({:ok, user}) do
    """
     User #{user.username} created.
    """
    |> Main.show_creation()
  end

  def handle_creation({:error, changeset}) do
    changeset
    |> Main.show_creation()
  end

end
