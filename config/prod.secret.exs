# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :probase, Probase.Repo,
  username: "postgres",
  password: "",
  database: "probase_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  timeout: 80000,
  pool_timeout: 500_000,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "50")

# config :probase, Probase.Repo,
#   # ssl: true,
#   url: database_url,
#   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# secret_key_base =
#   System.get_env("SECRET_KEY_BASE") ||
#     raise """
#     environment variable SECRET_KEY_BASE is missing.
#     You can generate one by calling: mix phx.gen.secret
#     """

config :probase, ProbaseWeb.Endpoint,
  http: [port: 80, transport_options: [socket_opts: [:inet6]]],
  https: [
    port: 443,
    cipher_suite: :strong,
    certfile: "priv/cert/fullchain.pem",
    keyfile: "priv/cert/privkey.pem"
  ],
  secret_key_base: ""

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :probase, ProbaseWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
