defmodule InkFlier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      main_children()
      ++ game_children()
      ++ end_children()

    opts = [strategy: :one_for_one, name: InkFlier.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InkFlierWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def main_children do
    [
      InkFlierWeb.Telemetry,
      InkFlier.Repo,
      {DNSCluster, query: Application.get_env(:ink_flier, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InkFlier.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InkFlier.Finch},
      {Registry, keys: :unique, name: Registry.Game},
    ]
  end

  def game_children do
    if Application.get_env(:ink_flier, :supervise_games, true) do
      [
        InkFlier.GameSystem,
      ]
    else
      []
    end
  end

  def end_children do
    [
      InkFlierWeb.Endpoint
    ]
  end
end
