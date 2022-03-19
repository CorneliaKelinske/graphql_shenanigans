defmodule GraphqlShenanigansWeb.Resolvers.Metric do
  alias GraphqlShenanigans.Metric

  def get_count(_, %{request: request}, _) do
    {:ok, %{request: request, count: Metric.get_count(request, self())}}
  end
end
