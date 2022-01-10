defmodule GraphqlPractice.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlPractice.Repo

  alias GraphqlPractice.Accounts.User

  def list_users do
    Repo.all(User)
    |> Repo.preload(:uploads)
  end

  def get_user!(id) do
   Repo.get!(User, id)
   |> Repo.preload(:uploads)
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end


  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
