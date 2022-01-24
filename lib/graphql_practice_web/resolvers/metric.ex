defmodule GraphqlPracticeWeb.Resolvers.Metric do
  alias GraphqlPractice.Metric

  def get_count(_, %{request: request}, _) do
    case Metric.get_count(request) do
      nil -> {:ok, %{count: 0}}
      count -> {:ok, %{count: count}}
    end
  end
end
