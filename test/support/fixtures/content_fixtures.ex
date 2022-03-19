defmodule GraphqlShenanigans.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlShenanigans.Content` context.
  """

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        user_id: 1
      })
      |> GraphqlShenanigans.Content.create_upload()

    upload
  end

  def upload(%{user: user}) do
    {:ok, upload} =
      %{
        description: "some description",
        title: "some title",
        user_id: user.id
      }
      |> GraphqlShenanigans.Content.create_upload()

    %{upload: upload}
  end
end
