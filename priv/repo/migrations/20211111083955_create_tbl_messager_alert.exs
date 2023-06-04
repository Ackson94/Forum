defmodule Probase.Repo.Migrations.CreateTblMessagerAlert do
  use Ecto.Migration

  def change do
    create table(:tbl_messager_alert) do
      add :chat_id, :integer
      add :content, :string
      add :user_id, :integer
      timestamps()
    end
  end
end
