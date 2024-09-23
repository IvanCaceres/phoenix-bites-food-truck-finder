defmodule PhoenixBites.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixBitesWeb.Telemetry,
      PhoenixBites.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_bites, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixBites.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixBites.Finch},
      # Start a worker by calling: PhoenixBites.Worker.start_link(arg)
      # {PhoenixBites.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixBitesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixBites.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixBitesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
