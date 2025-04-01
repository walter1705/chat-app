defmodule DB.Schemas.ChatRoom do
  use Ecto.Schema
  use Ecto.Changeset

  schema "chat_rooms" do
    field(:name, :string, unique: true)
    field(:hash_password, :string)
    field(:is_private, :boolean, default: false)
    timestamps()
  end

  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name, :hash_password, :is_private])
    |> validate_required([:name, :hash_password, :is_private])
    |> validate_length(:name, min: 3)
    |> validate_length(:name, max: 15)
    |> validate_length(:hash_password, min: 2)
    |> validate_length(:hash_password, max: 150)
    |> unique_constraint(:name)
  end

end
