defmodule GraphqlPracticeWeb.Resolvers.User do
  alias GraphqlPractice.Accounts
  alias GraphqlPractice.Accounts.User

  def users(_, _, _) do
    {:ok, Accounts.list_users()}
  end

  def get_user(_, %{id: id}, _) do
    {:ok, Accounts.get_user!(id)}
  end

  def get_user_by_name(_, %{name: name}, _) do
    {:ok, Accounts.get_user_by_name(name)}
  end

  def create_user(_, params, _) do
    case Accounts.create_user(params) do
      {:error, changeset} ->
        {:error, changeset}

      {:ok, user} ->
        {:ok, %{user: user}}
    end
  end

  def update_user(_, %{id: id} = params, _) do
    params = Map.delete(params, :id)

    with %User{} = user <- Accounts.get_user(id),
         {:ok, updated_user} <- Accounts.update_user(user, params) do
      {:ok, %{user: updated_user}}
    else
      {:error, changeset} -> {:error, changeset}
      nil -> {:error, message: "User not found!"}
    end
  end

  def delete_user(_, %{id: id}, _) do
    with %User{} = user <- Accounts.get_user(id),
         {:ok, deleted_user} <- Accounts.delete_user(user) do
      {:ok, %{user: deleted_user}}
    else
      {:error, changeset} -> {:error, changeset}
      nil -> {:error, message: "User not found!"}
    end
  end
end
