defmodule Probase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Probase.Repo,
      # Start the Telemetry supervisor
      ProbaseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Probase.PubSub},
      # Start the Endpoint (http/https)
      ProbaseWeb.Endpoint,
      ProbaseWeb.Presence,
      Probase.Scheduler
      # Start a worker by calling: Probase.Worker.start_link(arg)
      # {Probase.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Probase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ProbaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
