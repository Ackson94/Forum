defmodule Probase.Repo.Migrations.AddChatsTable do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :name, :string, null: false
      add :first_name, :string
      add :user_id, :integer
      add :date, :string
      timestamps()
    end

    create unique_index(:chats, [:name])
  end
end
