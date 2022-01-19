defmodule GraphqlPracticeWeb.Schema.Mutations.UploadTest do
  use GraphqlPractice.DataCase, async: true
  import GraphqlPractice.AccountsFixtures

  alias GraphqlPracticeWeb.Schema
  alias GraphqlPractice.Content
  alias GraphqlPractice.Content.Upload

  @create_upload_doc """
   mutation CreateUpload($title: String!, $description: String!, $user_id: ID!){
     createUpload(title: $title, description: $description, user_id: $user_id){
     errors{
       details
       key
       message
     }
     upload{
      id
      title
      description
      user {
        name
        id
      }
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

      assert %{"createUpload" => %{"errors" => nil, "upload" => upload}} = data

      assert Map.get(upload, "title") === create_title
      assert Map.get(upload, "description") === create_description
      assert get_in(upload, ["user", "id"]) === to_string(user_id)

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

      assert [%{details: _details, message: _message, path: _path}] = errors
    end
  end
end
