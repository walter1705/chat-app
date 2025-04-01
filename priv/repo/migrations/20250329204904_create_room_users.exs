defmodule ChatApp.DB.Repo.Migrations.CreateRoomUsers do
  use Ecto.Migration

  use Ecto.Changeset

  def change do
    create table(:chatroom_users) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :room_id, references(:chat_rooms, on_delete: :nothing), null: false
      add :joined_at, :utc_datetime, default: fragment("CURRENT_TIMESTAMP")
    end

  end

end
