defmodule Probase.Accounts.Sector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sectors" do
    field :description, :string
    field :sector_code, :string
    field :sector_code_filename, :string

    timestamps()
  end

  @doc false
  def changeset(sector, attrs) do
    sector
    |> cast(attrs, [:sector_code, :description, :sector_code_filename])
    |> validate_required([:sector_code, :description, :sector_code_filename])
  end
end
