defmodule ChatApp.Service.DataService do
  alias ChatApp.Data.Repo
  require Bcrypt
  alias DB.Schemas.{User, ChatRoom}

  @moduledoc """
  This module is the service of the application adn contains
  important functions
  """

  @doc """
  Creates a user communicating with the repo and hashing the password.

  iex> case Repo.insert(changeset) do
        {:ok, user} -> IO.inspect(user, label: "useer created")
        {:error, changeset} -> IO.inspect(changeset.errors, label: "Error")
  """
  @spec create_user(String.t(), any()) :: {atom(), %{}}
  def create_user(username, password) do
    hashed_password = Bcrypt.hash_pwd_salt(password)

    attrs = %{
      username: username,
      password_hash: hashed_password
    }

    changeset = User.changeset(%User{}, attrs)
    Repo.insert(changeset)
  end

  @doc """
  Get a user from the table by username

  #example:

    iex> case Repo.get_by(User, username: "username") do
        nil -> IO.puts("User not found")
        user -> IO.inspect(user, label: "user found")
      end
  """
  @spec get_user(String.t()) :: nil | %{}
  def get_user(username) do
    Repo.get_by(User, username: username)
    |> case do
      user=%User{} ->
        user
        |> Map.from_struct()
        |> Map.drop([:__meta__])

      nil ->
        nil
    end
  end

  @doc """
  Get all the user from the table and transform it from structu User to map
  return a list of the users (maps):
  %{username: ..., hash_password: ..., created_at: .., updated_at: ...}
  """
  @spec get_users() :: list()
  def get_users() do
    Repo.all(User)
    |> Enum.map(fn user ->
      user
      |> Map.from_struct()
      |> Map.drop([:__meta__])
    end)
  end

  @doc """
  Creates a chat room communicating with the repo and hashing the password.
  iex> case Repo.insert(changeset) do
        {:ok, room} -> IO.inspect(room, label: "room created")
        {:error, changeset} -> IO.inspect(changeset.errors, label: "Error")
  """
  @spec create_room(String.t(), String.t(), boolean()) :: {atom(), %{}}
  def create_room(name, password, is_private?) do
    hashed_password = Bcrypt.hash_pwd_salt(password)

    attrs = %{
      name: name,
      hash_password: hashed_password,
      is_private: is_private?
    }

    changeset = ChatRoom.changeset(%ChatRoom{}, attrs)
    Repo.insert(changeset)
  end

  @doc """
  Get all the chat rooms from the table and transform it from its Struct to map
  return a list of the chat rooms (maps):
  %{id: ..., name: ..., hash: ..., is_private: ...,created_at: .., updated_at: ...}
  """
  @spec get_rooms() :: list()
  def get_rooms() do
    Repo.all(ChatRoom)
    |> Enum.map(fn room ->
      room
      |> Map.from_struct()
      |> Map.drop([:__meta__])
    end)
  end
end
