defmodule GraphqlPracticeWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A person using the application"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :uploads, list_of(:upload), resolve: dataloader(GraphqlPractice.Content, :uploads)
  end

  @desc "The input to create a user"
  input_object :user_input do
    field :name, :string
    field :email, :string
  end

  object :user_result do
    field :user, :user
    field :errors, list_of(:input_error)
  end

  @desc "Ecto changeset errors from an input"
  object :input_error do
    field :key, :string
    field :message, :string
    field :details, :string
  end
end
