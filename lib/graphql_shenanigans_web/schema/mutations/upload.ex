defmodule GraphqlShenanigansWeb.Schema.Mutations.Upload do
  use Absinthe.Schema.Notation
  alias GraphqlShenanigansWeb.Resolvers

  object :upload_mutations do
    @desc "Creates an upload"
    field :create_upload, :upload do
      arg :title, non_null(:string)
      arg :description, non_null(:string)
      arg :user_id, non_null(:id)

      resolve &Resolvers.Upload.create_upload/3
    end

    @desc "Updates an upload"
    field :update_upload, :upload do
      arg :id, non_null(:id)
      arg :title, :string
      arg :description, :string

      resolve &Resolvers.Upload.update_upload/3
    end

    @desc "Deletes an upload"
    field :delete_upload, :upload do
      arg :id, non_null(:id)

      resolve &Resolvers.Upload.delete_upload/3
    end
  end
end
