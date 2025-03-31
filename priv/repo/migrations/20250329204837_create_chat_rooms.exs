defmodule ChatApp.DB.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms) do
      add :name, :string, null: false, unique: true
      add :created_at, :utc_datetime, default: fragment("CURRENT_TIMESTAMP")

      timestamps()
    end
  end
end
