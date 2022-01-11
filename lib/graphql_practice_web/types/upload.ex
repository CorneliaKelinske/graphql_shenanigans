defmodule GraphqlPracticeWeb.Types.Upload do
  use Absinthe.Schema.Notation

  @desc "An image uploaded by a user"
  object :upload do
    field :id, :id
    field :title, :string
    field :description, :string

    field :user, :user
  end
end
