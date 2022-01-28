defmodule GraphqlPracticeWeb.Schema.Mutations.UploadTest do
  use GraphqlPractice.DataCase, async: true
  import GraphqlPractice.AccountsFixtures
  import GraphqlPractice.ContentFixtures

  alias GraphqlPracticeWeb.Schema
  alias GraphqlPractice.Content
  alias GraphqlPractice.Content.Upload

  @create_upload_doc """
   mutation CreateUpload($title: String!, $description: String!, $user_id: ID!){
     createUpload(title: $title, description: $description, user_id: $user_id){
      id
      title
      description
      user {
        name
        id
      }
   }
  }
  """

  describe "@create_upload" do
    setup [:user]

    test "Creates a new upload", %{user: user} do
      user_id = user.id
      create_title = "some title"
      create_description = "showing some random thing"

      assert {:ok, %{data: data}} =
               Absinthe.run(@create_upload_doc, Schema,
                 variables: %{
                   "title" => create_title,
                   "description" => create_description,
                   "user_id" => user_id
                 }
               )

      assert %{"createUpload" => upload} = data
      string_user_id = to_string(user_id)

      assert %{
               "title" => ^create_title,
               "description" => ^create_description,
               "user" => %{"id" => ^string_user_id}
             } = upload

      string_id = Map.get(upload, "id")
      id = String.to_integer(string_id)

      assert %Upload{title: ^create_title, description: ^create_description, id: ^id} =
               Content.get_upload!(id)
    end

    test "Returns errors when invalid input arguments are provided", %{user: user} do
      user_id = user.id
      create_title = ""
      create_description = ""

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_upload_doc, Schema,
                 variables: %{
                   "title" => create_title,
                   "description" => create_description,
                   "user_id" => user_id
                 }
               )

      assert [
               %{message: "description: can't be blank", path: ["createUpload"]},
               %{message: "title: can't be blank", path: ["createUpload"]}
             ] = errors
    end
  end

  @update_upload_doc """
   mutation UpdateUpload($id: Id!, $title: String, $description: String){
    updateUpload(id: $id, title: $title, description: $description){
     id
     title
     description
     user {
       name
       id
     }
  }
  }
  """

  describe "@update_upload" do
    setup [:user, :upload]

    test "Updates an upload when valid params are provided", %{upload: upload} do
      update_title = "updated title"
      update_description = "updated description"
      id = upload.id

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_upload_doc, Schema,
                 variables: %{
                   "title" => update_title,
                   "description" => update_description,
                   "id" => id
                 }
               )

      assert %{"updateUpload" => upload} = data

      assert %{
               "title" => ^update_title,
               "description" => ^update_description
             } = upload
    end

    test "Returns errors when ID is not found", %{upload: upload} do
      update_title = "updated title"
      update_description = "updated description"
      non_existent_id = upload.id + 1

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_upload_doc, Schema,
                 variables: %{
                   "title" => update_title,
                   "description" => update_description,
                   "id" => non_existent_id
                 }
               )

      assert [%{message: "Upload not found!", path: ["updateUpload"]}] = errors
    end
  end

  @delete_upload_doc """
   mutation DeleteUpload($id: Id!){
    deleteUpload(id: $id){
     id
     title
     description
     user {
       name
       id
     }
  }
  }
  """

  describe "@delete_upload" do
    setup [:user, :upload]

    test "Deletes an upload when valid id is provided", %{upload: upload} do
      id = upload.id

      assert {:ok, %{data: data}} =
               Absinthe.run(@delete_upload_doc, Schema,
                 variables: %{
                   "id" => id
                 }
               )

      string_id = to_string(id)

      assert %{"deleteUpload" => deleted_upload} = data

      assert %{"description" => "some description", "id" => ^string_id, "title" => "some title"} =
               deleted_upload

      assert_raise Ecto.NoResultsError, fn -> Content.get_upload!(id) end
    end
  end
end
