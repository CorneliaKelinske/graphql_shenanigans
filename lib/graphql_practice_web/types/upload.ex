defmodule GraphqlPracticeWeb.Types.Upload do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "An image uploaded by a user"
  object :upload do
    field :id, :id
    field :title, :string
    field :description, :string

    field :user, :user, resolve: dataloader(GraphqlPractice.Accounts, :user)
  end

  object :upload_result do
    field :upload, :upload
    field :errors, list_of(:input_error)
  end
end
