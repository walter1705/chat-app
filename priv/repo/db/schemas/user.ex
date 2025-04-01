defmodule DB.Schemas.User do
  use Ecto.Schema
  use Ecto.Changeset

  schema "users" do
    field(:username, :string, unique: true)
    field(:password_hash, :string)
    belongs_to(:chat_room, DB.Schemas.ChatRoom)
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
    |> validate_length(:username, min: 3)
    |> validate_length(:username, max: 15)
    |> validate_length(:password_hash, min: 8)
    |> validate_length(:password_hash, max: 150)
    |> unique_constraint(:username)
  end
end
