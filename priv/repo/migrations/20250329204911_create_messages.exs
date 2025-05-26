defmodule ChatApp.DB.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :chat_room_id, references(:chat_rooms, on_delete: :nothing), null: false
      add :content, :text, null: false
      add :sent_at, :utc_datetime, default: fragment("CURRENT_TIMESTAMP")

      timestamps()
    end
  end
end
