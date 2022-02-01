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

  @all_upload_params [@upload1_params, @upload2_params, @upload3_params]

  @upload_doc """
    query getUpload($id: ID){
      upload(id: $id){
        title,
        description,
        id,
        user{
          name,
          email,
          id
        }
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

  @upload_by_title_doc """
    query getUploadbyTitle($title: String){
      uploadByTitle(title: $title){
        description,
        id,
        user{
          name,
          email,
          id
        }
      }
    }
  """

  describe "@upload_by_title" do
    setup [:user]

    test "Can get the upload by its title", %{
      user: %{id: user_id, name: name, email: email} = user
    } do
      upload1_params = Map.put(@upload1_params, :user_id, user.id)
      assert {:ok, upload1} = Content.create_upload(upload1_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@upload_by_title_doc, Schema, variables: %{"title" => upload1.title})

      id = to_string(upload1.id)
      user_id = to_string(user_id)

      assert %{
               "uploadByTitle" => %{
                 "description" => "a picture showing more stuff",
                 "id" => ^id,
                 "user" => %{"email" => ^email, "id" => ^user_id, "name" => ^name}
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
          id
        }
      }
    }
  """

  describe "@uploads" do
    setup [:user]

    test "Returns a list of all uploads", %{user: %{id: user_id, name: name, email: email} = user} do
      [%{id: upload1_id}, %{id: upload2_id}, %{id: upload3_id}] =
        for params <- @all_upload_params do
          assert {:ok, upload} = params |> Map.put(:user_id, user.id) |> Content.create_upload()
          upload
        end

      assert {:ok, %{data: data}} = Absinthe.run(@uploads_doc, Schema)

      assert %{"uploads" => uploads} = data

      upload1_id = to_string(upload1_id)
      upload2_id = to_string(upload2_id)
      upload3_id = to_string(upload3_id)

      assert [
               %{
                 "description" => "a picture showing more stuff",
                 "id" => ^upload1_id,
                 "title" => "another picture",
                 "user" => %{"email" => ^email, "name" => ^name}
               },
               %{
                 "description" => "a picture showing the sunset",
                 "id" => ^upload2_id,
                 "title" => "Abendhimmel",
                 "user" => %{"email" => ^email, "name" => ^name}
               },
               %{
                 "description" => "a picture showing the sunrise",
                 "id" => ^upload3_id,
                 "title" => "Morgenhimmel",
                 "user" => %{"email" => ^email, "name" => ^name}
               }
             ] = Enum.sort_by(uploads, & &1["id"])
    end
  end
end
