defmodule DB.Schemas.Message do
  use Ecto.Schema

  use Ecto.Changeset

  schema "messages" do
    belongs_to(:user, DB.Schemas.User)
    belongs_to(:chat_room, DB.Schemas.ChatRoom)
    field(:content, :string)
    field(:sent_at, :utc_datetime)
    timestamps()
  end


  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :chat_room_id, :content])
    |> validate_required([:user_id, :chat_room_id, :content])
    |> validate_length(:content, min: 1)
    |> validate_length(:content, max: 2000)
  end
end
