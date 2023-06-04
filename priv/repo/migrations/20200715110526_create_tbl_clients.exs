defmodule Probase.Repo.Migrations.CreateTblClients do
  use Ecto.Migration

  def change do
    create table(:tbl_clients) do
      add :company_name, :string
      add :email, :string
      add :"p.o_box", :string
      add :phone, :string
      add :country, :string
      add :address, :string

      timestamps()
    end
  end
end
