defmodule GraphqlShenanigansWeb.Schema.Queries.Metric do
  use Absinthe.Schema.Notation
  alias GraphqlShenanigansWeb.Resolvers

  object :metric_query do
    @desc "Queries how often the GraphQL server has received a given request"
    field :count_request, :request_count do
      arg :request, non_null(:string)
      resolve &Resolvers.Metric.get_count/3
    end
  end
end
