defmodule GraphqlShenanigansWeb.Types.Metric do
  use Absinthe.Schema.Notation

  @desc "The number of times a the GraphqlServer has received a given request"
  object :request_count do
    field :request, :string
    field :count, :integer
  end
end
