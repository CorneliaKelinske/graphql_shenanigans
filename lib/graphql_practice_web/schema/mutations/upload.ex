defmodule GraphqlPracticeWeb.Schema.Mutations.Upload do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :upload_mutations do
    @desc "Creates an upload"
    field :create_upload, :upload_result do
      arg :title, non_null(:string)
      arg :description, non_null(:string)
      arg :user_id, non_null(:id)

      resolve(&Resolvers.Upload.create_upload/3)
    end
  end
end
