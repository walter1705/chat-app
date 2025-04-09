defmodule ChatApp.Service.AuthService do
  @moduledoc """
  This module is the service of the application for authentication.
  """
  alias ChatApp.Service.DataService
  @doc """
  Log in function return: {:error, reason} | {:ok, user}

  #example

    iex> login("username", "password")
    {:ok, %{...}} #(user map)

    iex> login("username", "wrong_password")
    {:error, "Invalid password"}

    iex> login("wrong_username", "password")
    {:error, "User not found"}
  """
  def login(username, password) do
    case DataService.get_user(username) do
      user=%{} ->
        case Bcrypt.verify_pass(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, "Invalid password"}
        end

      _ ->
        {:error, "User not found"}
    end
  end
end
