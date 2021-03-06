defmodule GraphqlShenanigansWeb.Schema.Queries.MetricTest do
  use GraphqlShenanigans.DataCase, async: true
  alias GraphqlShenanigansWeb.Schema
  alias GraphqlShenanigans.Metric

  use ExUnit.Case, async: true

  @users_doc """
  query getUsers{
   users{
     id
     name
     email
     uploads {
       title
       description
       id
     }
   }
  }
  """

  @count_request_doc """
  query countRequest($request: String!){
    countRequest(request: $request){
      request
      count
    }
  }
  """

  describe "@count_request" do
    setup do
      start_supervised!({GraphqlShenanigans.Metric, self()})
      :ok
    end

    test "returns a count of 0 for a given request when the request has not yet been made" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@count_request_doc, Schema, variables: %{"request" => "users"})

      assert %{"countRequest" => %{"count" => 0, "request" => "users"}} = data
    end

    test "returns the correct count for a given request when the request has been made" do
      assert {:ok, %{data: data}} = Absinthe.run(@users_doc, Schema)
      Absinthe.run(@users_doc, Schema)

      assert {:ok, %{data: data}} =
               Absinthe.run(@count_request_doc, Schema, variables: %{"request" => "users"})

      assert %{"countRequest" => %{"count" => 2, "request" => "users"}} = data
    end
  end
end
