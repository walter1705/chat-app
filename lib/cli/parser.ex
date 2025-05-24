defmodule CLI.Parser do
  @moduledoc """
  Parses the input/request of the user.
  """

  @doc """
  Parse the args received from the user and check if
  they are valid or not.
  Also handle most of the request of the module request.
  """
  alias DB.Schemas.User
  alias CLI.{Client, Request, Main, Util}

  @spec parse_args([binary()]) :: no_return()
  def parse_args(args) do
    OptionParser.parse(args,
      switches: [help: :boolean],
      alias: [h: :help]
    )
    |> elem(1)
    |> handle_parse()
  end

  def handle_parse(["host", ip]) do
    # TODO
    Request.request_list_all_users()
  end

  @spec handle_parse(any()) :: no_return()
  def handle_parse(["client", username, password, ip]) do
    case Request.request_log_in(username, password) do
      {:ok, user} ->
        try_connect_user(user, ip)

      {:error, message} ->
        message
        |> Util.print_message()

        Util.client_log_in_help()
        |> Util.print_message()
    end
  end

  def handle_parse(["register", username, password]) do
    user_created? = Request.request_create_user(username, password)
    handle_creation(user_created?)
  end

  def handle_parse(["help"]) do
    Util.list_options()
    |> Util.print_message()
  end

  def handle_parse("-h") do
    Util.list_options()
    |> Util.print_message()
  end

  def handle_parse(_) do
    Util.help_commands()
    |> Util.print_message()
  end

  @spec try_connect_user(any(), any()) :: no_return()
  def try_connect_user(user, ip) do
    case Request.try_connect_user(user, ip) do
      {:ok, _} ->
        Util.welcome_message(user.username)
        |> Util.print_message()

      {:error, message} ->
        (Util.client_log_in_help() <> message)
        |> Util.print_message()
    end
  end

  @doc """
  Handle the creation of an entity.
  """
  @spec handle_creation(any()) :: no_return()
  def handle_creation({:ok, %User{} = user}) do
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
