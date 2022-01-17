defmodule GraphqlPracticeWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :user_queries do
    @desc "Provides a list of all users"
    field :users, list_of(:user) do
      resolve &Resolvers.User.users/3
    end

    @desc "Gets a user by id"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve &Resolvers.User.get_user/3
    end

    @desc "Gets a user by their name"
    field :user_by_name, :user do
      arg(:name, non_null(:string))
      resolve &Resolvers.User.get_user_by_name/3
    end
  end
end
