defmodule Probase.Repo.Migrations.CreateTblHistoryAnnounce do
  use Ecto.Migration

  def change do
    create table(:tbl_history_announce) do
      add :name, :string
      add :first_name, :string
      add :status, :string

      timestamps()
    end
  end
end
