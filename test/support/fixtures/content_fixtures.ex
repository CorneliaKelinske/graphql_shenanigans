defmodule GraphqlPractice.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlPractice.Content` context.
  """

  @doc """
  Generate a uplod.
  """
  def uplod_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        description: "some description",
        text: "some text",
        title: "some title"
      })
      |> GraphqlPractice.Content.create_upload()

    upload
  end
end
