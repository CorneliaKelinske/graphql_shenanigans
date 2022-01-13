defmodule GraphqlPracticeWeb.Schema.Queries.UploadTest do
  use GraphqlPractice.DataCase, async: true
  import GraphqlPractice.AccountsFixtures
  alias GraphqlPractice.Content
  alias GraphqlPracticeWeb.Schema

  @upload1_params %{
    title: "another picture",
    description: "a picture showing more stuff"
  }
  @upload2_params %{
    title: "Abendhimmel",
    description: "a picture showing the sunset",
    user_id: 2
  }
  @upload3_params %{
    title: "Morgenhimmel",
    description: "a picture showing the sunrise",
    user_id: 2
  }

  @upload_doc """
    query getUpload($id: ID){
      upload(id: $id){
        title,
        description
      }
    }
  """

  describe "@upload" do
    setup [:user]

    test "Can get the upload by ID", %{user: user} do
      upload1_params = Map.put(@upload1_params, :user_id, user.id)
      assert {:ok, upload1} = Content.create_upload(upload1_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@upload_doc, Schema, variables: %{"id" => upload1.id})

      assert %{
               "upload" => %{
                 "description" => "a picture showing more stuff",
                 "title" => "another picture"
               }
             } = data
    end
  end

  @uploads_doc """
    query getUploads{
      uploads {
        title
        description
        id
        user {
          name
          email
        }
      }
    }
  """

  describe "@uploads" do
    setup [:user]

    test "Returns a list of all uploads", %{user: user} do
      upload1_params = Map.put(@upload1_params, :user_id, user.id)
      upload2_params = Map.put(@upload2_params, :user_id, user.id)
      upload3_params = Map.put(@upload3_params, :user_id, user.id)

      assert {:ok, upload1} = Content.create_upload(upload1_params)
      assert {:ok, upload2} = Content.create_upload(upload2_params)
      assert {:ok, upload3} = Content.create_upload(upload3_params)

      assert {:ok, %{data: data}} = Absinthe.run(@uploads_doc, Schema)


      assert %{"uploads" => uploads} = data

      assert List.last(uploads)["id"] === to_string(upload3.id)

    end
  end

end
