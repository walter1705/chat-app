defmodule DB.Schemas.ChatRoomUser do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chatroom_users" do
    field(:joined_at, :utc_datetime)
    belongs_to(:user, DB.Schemas.User)
    belongs_to(:chat_room, DB.Schemas.ChatRoom)
  end

  def changeset(chat_room_user, attrs) do
    chat_room_user
    |> cast(attrs, [:user_id, :chat_room_id])
    |> validate_required([:user_id, :chat_room_id])
  end
end
