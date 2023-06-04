defmodule Probase.Repo do
  use Ecto.Repo,
    otp_app: :probase,
    adapter: Ecto.Adapters.Postgres
    # adapter: Ecto.Adapters.Tds
end
