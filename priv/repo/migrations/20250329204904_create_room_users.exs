defmodule ChatApp.DB.Repo.Migrations.CreateRoomUsers do
  use Ecto.Migration

  def change do
    create table(:room_users) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :room_id, references(:chat_rooms, on_delete: :delete_all), null: false
      add :joined_at, :utc_datetime, default: fragment("CURRENT_TIMESTAMP")

      timestamps()
    end

    create unique_index(:room_users, [:user_id, :room_id])
  end
end
