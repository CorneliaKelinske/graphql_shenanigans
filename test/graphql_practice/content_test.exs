defmodule GraphqlPractice.ContentTest do
  use GraphqlPractice.DataCase

  alias GraphqlPractice.Content

  describe "uploads" do
    alias GraphqlPractice.Content.Uplod

    import GraphqlPractice.ContentFixtures

    @invalid_attrs %{description: nil, text: nil, title: nil}

    test "list_uploads/0 returns all uploads" do
      uplod = uplod_fixture()
      assert Content.list_uploads() == [uplod]
    end

    test "get_uplod!/1 returns the uplod with given id" do
      uplod = uplod_fixture()
      assert Content.get_uplod!(uplod.id) == uplod
    end

    test "create_uplod/1 with valid data creates a uplod" do
      valid_attrs = %{description: "some description", text: "some text", title: "some title"}

      assert {:ok, %Uplod{} = uplod} = Content.create_uplod(valid_attrs)
      assert uplod.description == "some description"
      assert uplod.text == "some text"
      assert uplod.title == "some title"
    end

    test "create_uplod/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_uplod(@invalid_attrs)
    end

    test "update_uplod/2 with valid data updates the uplod" do
      uplod = uplod_fixture()

      update_attrs = %{
        description: "some updated description",
        text: "some updated text",
        title: "some updated title"
      }

      assert {:ok, %Uplod{} = uplod} = Content.update_uplod(uplod, update_attrs)
      assert uplod.description == "some updated description"
      assert uplod.text == "some updated text"
      assert uplod.title == "some updated title"
    end

    test "update_uplod/2 with invalid data returns error changeset" do
      uplod = uplod_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_uplod(uplod, @invalid_attrs)
      assert uplod == Content.get_uplod!(uplod.id)
    end

    test "delete_uplod/1 deletes the uplod" do
      uplod = uplod_fixture()
      assert {:ok, %Uplod{}} = Content.delete_uplod(uplod)
      assert_raise Ecto.NoResultsError, fn -> Content.get_uplod!(uplod.id) end
    end

    test "change_uplod/1 returns a uplod changeset" do
      uplod = uplod_fixture()
      assert %Ecto.Changeset{} = Content.change_uplod(uplod)
    end
  end
end
