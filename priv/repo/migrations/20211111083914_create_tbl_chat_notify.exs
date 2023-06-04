defmodule Probase.Repo.Migrations.CreateTblChatNotify do
  use Ecto.Migration

  def change do
    create table(:tbl_chat_notify) do
      add :name, :string
      add :first_name, :string
      add :user_id, :integer
      add :status, :string
      timestamps()
    end

    create unique_index(:tbl_chat_notify, [:name])
  end
end
