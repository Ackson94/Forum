defmodule Probase.Repo.Migrations.AddColumnAnn do
  use Ecto.Migration

  def up do
    alter table(:tbl_messager_alert) do
      add :doc_string, :text
      add :doc_name, :string
      add :doc_type, :string
    end
  end

  def down do
    alter table(:tbl_messager_alert) do
      remove (:doc_string)
      remove (:doc_name)
      remove (:doc_type)
    end
  end
end
