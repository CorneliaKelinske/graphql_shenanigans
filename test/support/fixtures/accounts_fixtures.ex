defmodule GraphqlShenanigans.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlShenanigans.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    email = Faker.Internet.email
    name = Faker.Person.En.first_name()
    {:ok, user} =
      attrs
      |> Enum.into(%{email: email, name: name})
      |> GraphqlShenanigans.Accounts.create_user()

    user
  end

  def user(_) do
    email = Faker.Internet.email
    name = Faker.Person.En.first_name()
    {:ok, user} =
      %{email: email, name: name}
      |> GraphqlShenanigans.Accounts.create_user()

    %{user: Map.put(user, :uploads, [])}
  end
end
