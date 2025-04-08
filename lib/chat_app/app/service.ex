defmodule ChatApp.App.Service do
  alias ChatApp.Data.Repo
  require Bcrypt
  alias DB.Schemas.{User}

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
  @spec create_user(String.t(), String.t()) :: {atom(), %{}}
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
  Get all the user from the table and transform it from structu User to map
  return a list of the users (maps):
  %{username: ..., hash_password: ..., created_at: .., updated_at: ...}
  """
  @spec get_users() :: list()
  def get_users() do
    Repo.all(User)
    |> Enum.map(&Map.from_struct/1)
  end

end
