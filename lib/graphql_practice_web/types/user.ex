defmodule GraphqlPracticeWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "A person using the application"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :uploads, list_of(:upload)
  end
end
