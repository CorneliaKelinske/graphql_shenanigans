defmodule GraphqlPracticeWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :user_mutations do
    @desc "Creates a user"
    field :create_user, :user_result do
      arg :name, non_null(:string)
      arg :email, non_null(:string)

      resolve &Resolvers.User.create_user/3
    end

    @desc "Updates a user"
    field :update_user, :user_result do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string

      resolve &Resolvers.User.update_user/3
    end

    @desc "Deletes a user"
    field :delete_user, :user_result do
      arg :id, non_null(:id)

      resolve &Resolvers.User.delete_user/3
    end
  end
end
