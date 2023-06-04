defmodule Probase.Accounts.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_clients" do
    field :address, :string
    field :company_name, :string
    field :country, :string
    field :email, :string
    # field :"p.o_box", :string
    field :phone, :string
    field :po_box, :string
    field :sector_code, :string

    timestamps()
  end
  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:company_name, :email, :phone, :country, :address, :po_box, :sector_code])
    |> validate_required(:email, message: "Email Already Exist")
    # |> unique_constraint(:email, name: :tbl_clients_email_index, message: " address already exists")
  end
end
