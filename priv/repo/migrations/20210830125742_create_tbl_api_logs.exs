defmodule Probase.Repo.Migrations.CreateTblApiLogs do
  use Ecto.Migration

  def change do
    create table(:tbl_api_logs) do
      add :response, :string
      add :request, :string

      timestamps()
    end

  end
end
