defmodule InkFlier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InkFlierWeb.Telemetry,
      InkFlier.Repo,
      {DNSCluster, query: Application.get_env(:ink_flier, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InkFlier.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InkFlier.Finch},
      # Start a worker by calling: InkFlier.Worker.start_link(arg)
      # {InkFlier.Worker, arg},
      # Start to serve requests, typically the last entry
      {Registry, keys: :unique, name: Registry.Game},
      InkFlier.LobbyServer,
      {InkFlier.GameServer, {"321", "Robin"}},
      InkFlierWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InkFlier.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InkFlierWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
