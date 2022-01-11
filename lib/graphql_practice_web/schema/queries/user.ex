defmodule GraphqlPracticeWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias GraphqlPractice.Accounts

  object :user_queries do
    @desc "Provides a list of all users"
    field :users, list_of(:user) do
      resolve fn _, _, _ ->
        {:ok, Accounts.list_users()}
      end
    end

    @desc "Gets a user by id"
    field :user, :user do
      arg(:id, non_null(:id))

      resolve fn _, %{id: id}, _ ->
        {:ok, Accounts.get_user!(id)}
      end
    end
  end
end
