defmodule Probase.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :chat_id, :integer
      add :content, :text
      add :user_id, :integer
      add :doc_string, :text
      add :doc_name, :string
      add :doc_type, :string
 

      timestamps()
    end
  end
end
