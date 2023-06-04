defmodule Probase.History.Announce do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_history_announce" do
    field :first_name, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(announce, attrs) do
    announce
    |> cast(attrs, [:name, :first_name, :status])
    |> validate_required([:name, :first_name, :status])
  end
end
