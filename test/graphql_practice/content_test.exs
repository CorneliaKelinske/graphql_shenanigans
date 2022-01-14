defmodule GraphqlPractice.ContentTest do
  use GraphqlPractice.DataCase
  import GraphqlPractice.ContentFixtures
  import GraphqlPractice.AccountsFixtures
  alias GraphqlPractice.Content
  alias GraphqlPractice.Content.Upload

  @invalid_attrs %{description: nil, title: nil}

  setup [:user, :upload]

  describe "list_uploads/0" do
    test "returns all uploads", %{upload: upload} do
      expected_upload_list = set_nil_user([upload])
      retrieved_upload_list = Content.list_uploads() |> set_nil_user()
      assert retrieved_upload_list === expected_upload_list
    end
  end

  describe "get_upload!/1" do
    test "get_upload!/1 returns the upload with given id", %{upload: upload} do
      expected_upload = set_nil_user(upload)
      retrieved_upload = upload.id |> Content.get_upload!() |> set_nil_user()
      assert retrieved_upload === expected_upload
    end
  end

  describe "create_upload/1" do
    test "creates upload when valid data is provided", %{user: user} do
      valid_attrs = %{description: "some description", title: "some title", user_id: user.id}

      assert {:ok, %Upload{} = upload} = Content.create_upload(valid_attrs)
      assert upload.description == "some description"
      assert upload.title == "some title"
    end

    test "returns error changeset when invalid data is provided", %{user: user} do
      invalid_attrs = Map.put(@invalid_attrs, :user_id, user.id)
      assert {:error, %Ecto.Changeset{}} = Content.create_upload(invalid_attrs)
    end
  end

  describe "update_upload/2" do
    test "updates the upload when valid data is provided", %{upload: upload} do
      update_attrs = %{
        description: "some updated description",
        title: "some updated title"
      }

      assert {:ok, %Upload{} = upload} = Content.update_upload(upload, update_attrs)
      assert upload.description == "some updated description"
      assert upload.title == "some updated title"
    end

    test "returns error changeset when invalid data is provided", %{upload: upload} do
      assert {:error, %Ecto.Changeset{}} = Content.update_upload(upload, @invalid_attrs)
      expected_upload = set_nil_user(upload)
      retrieved_upload = upload.id |> Content.get_upload!() |> set_nil_user()
      assert retrieved_upload === expected_upload
    end
  end

  describe "delete_upload/1" do
    test "deletes the upload", %{upload: upload} do
      assert {:ok, %Upload{}} = Content.delete_upload(upload)
      assert_raise Ecto.NoResultsError, fn -> Content.get_upload!(upload.id) end
    end
  end

  describe "change_upload/1" do
    test "returns a uplod changeset", %{upload: upload} do
      assert %Ecto.Changeset{} = Content.change_upload(upload)
    end
  end

  defp set_nil_user(list) when is_list(list) do
    Enum.map(list, &set_nil_user/1)
  end

  defp set_nil_user(map) when is_map(map) do
    Map.put(map, :user, nil)
  end
end
