defmodule GraphqlPractice.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlPractice.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", name: "some name"})
      |> GraphqlPractice.Accounts.create_user()

    user
  end

  def user(_) do
    {:ok, user} =
      %{email: "some email", name: "some name"}
      |> GraphqlPractice.Accounts.create_user()

    %{user: Map.put(user, :uploads, [])}
  end
end
