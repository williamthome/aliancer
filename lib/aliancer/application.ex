defmodule Aliancer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AliancerWeb.Telemetry,
      Aliancer.Repo,
      {DNSCluster, query: Application.get_env(:aliancer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Aliancer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Aliancer.Finch},
      # Start a worker by calling: Aliancer.Worker.start_link(arg)
      # {Aliancer.Worker, arg},
      # Start to serve requests, typically the last entry
      AliancerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aliancer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AliancerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
