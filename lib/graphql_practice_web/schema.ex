defmodule GraphqlPracticeWeb.Schema do
  use Absinthe.Schema
  alias GraphqlPractice.{Content, Accounts}


  query do
    @desc "Provides a list of all users"
    field :users, list_of(:user) do
      resolve fn _, _, _ ->
        {:ok, Accounts.list_users()}
      end
    end

    @desc "Gets a user by id"
    field :user, :user do
      arg(:id, non_null(:id))
      resolve fn _, %{id: id}, _ ->
        {:ok, Accounts.get_user!(id)}
      end
    end

    @desc "Provides a list of all uploads"
    field :uploads, list_of(:upload) do
      resolve fn _, _, _ ->
        {:ok, Content.list_uploads()}
      end
    end

    @desc "Gets an upload by id"
    field :upload, :upload do
      arg(:id, non_null(:id))
      resolve fn _, %{id: id}, _ ->
        {:ok, Content.get_upload!(id)}
      end
    end
  end


  @desc "An image uploaded by a user"
  object :upload do
    field :id, :id
    field :title, :string
    field :description, :string

    field :user, :user
  end

  @desc "A person using the application"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :uploads, list_of(:upload)
  end


end
