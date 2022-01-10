defmodule GraphqlPracticeWeb.Schema do
  use Absinthe.Schema


  query do
    field :uploads, list_of(:upload)

  end


  object :upload do
    field :id, :id
    field :title, :string
    field :description, :string

  end


end
