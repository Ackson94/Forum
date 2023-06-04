defmodule Probase.Repo.Migrations.CreateTblUsersAcc do
  use Ecto.Migration

  def change do
    create table(:tbl_users_acc) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :user_type, :integer
      add :user_role, :string
      add :status, :integer
      add :auto_password, :string
      add :user_id, :integer
      add :company_name, :string
      add :phone_no, :string

      timestamps()
    end

    create unique_index(:tbl_users_acc, [:email])
  end
end
