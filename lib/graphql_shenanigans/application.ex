defmodule GraphqlShenanigans.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        GraphqlShenanigans.Repo,
        # Start the Telemetry supervisor
        GraphqlShenanigansWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: GraphqlShenanigans.PubSub},
        # Start the Endpoint (http/https)
        GraphqlShenanigansWeb.Endpoint
        # Start a worker by calling: GraphqlShenanigans.Worker.start_link(arg)
        # {GraphqlShenanigans.Worker, arg}
      ] ++ metric()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlShenanigans.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlShenanigansWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Mix.env() !== :test do
    def metric, do: [{GraphqlShenanigans.Metric, self()}]
  else
    def metric, do: []
  end
end
