defmodule ChatApp.DB.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms) do
      add :name, :string, null: false, unique: true
      add :hash_password, :string, null: false
      add :is_private, :boolean, default: false, null: false
      timestamps()
    end
  end
end
