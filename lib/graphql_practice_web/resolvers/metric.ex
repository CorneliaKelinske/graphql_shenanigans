defmodule GraphqlPracticeWeb.Resolvers.Metric do
  alias GraphqlPractice.Metric

  def get_count(_, %{request: request}, _) do
    {:ok, %{count: Metric.get_count(request)}}
  end
end
