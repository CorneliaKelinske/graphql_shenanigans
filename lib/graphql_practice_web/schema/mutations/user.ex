defmodule GraphqlPracticeWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :user_mutations do
    @desc "Creates a user"
    field :create_user, :user_result do
      arg :input, non_null(:user_input)
      resolve(&Resolvers.User.create_user/3)
    end
  end
end
