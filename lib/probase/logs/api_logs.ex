defmodule Probase.Logs.Api_logs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_api_logs" do
    field :request, :string
    field :response, :string

    timestamps()
  end

  @doc false
  def changeset(api_logs, attrs) do
    api_logs
    |> cast(attrs, [:response, :request])

    # |> validate_required([:response, :request])
  end
end
