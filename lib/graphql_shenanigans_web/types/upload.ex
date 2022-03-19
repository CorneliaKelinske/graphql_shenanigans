defmodule GraphqlShenanigansWeb.Types.Upload do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "An image uploaded by a user"
  object :upload do
    field :id, :id
    field :title, :string
    field :description, :string

    field :user, :user, resolve: dataloader(GraphqlShenanigans.Accounts, :user)
  end
end
