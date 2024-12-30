defmodule Ef68425.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Ef68425Web.Telemetry,
      Ef68425.Repo,
      {DNSCluster, query: Application.get_env(:ef68425, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ef68425.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ef68425.Finch},
      # Start a worker by calling: Ef68425.Worker.start_link(arg)
      # {Ef68425.Worker, arg},
      # Start to serve requests, typically the last entry
      Ef68425Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ef68425.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Ef68425Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
