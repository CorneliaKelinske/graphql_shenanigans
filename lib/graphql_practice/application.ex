defmodule GraphqlPractice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        GraphqlPractice.Repo,
        # Start the Telemetry supervisor
        GraphqlPracticeWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: GraphqlPractice.PubSub},
        # Start the Endpoint (http/https)
        GraphqlPracticeWeb.Endpoint
        # Start a worker by calling: GraphqlPractice.Worker.start_link(arg)
        # {GraphqlPractice.Worker, arg}
      ] ++ metric()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlPractice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlPracticeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Mix.env() !== :test do
    def metric, do: [{GraphqlPractice.Metric, self()}]
  else
    def metric, do: []
  end
end
