defmodule Probase.Emails.Email_log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_email_alerts" do
    field :email, :string
    field :status, :string
    field :type, :string
    field :ticket_no, :string

    timestamps()
  end

  @doc false
  def changeset(email_log, attrs) do
    email_log
    |> cast(attrs, [:type, :email, :status, :ticket_no])
    |> validate_required([:type, :status])
  end
end
