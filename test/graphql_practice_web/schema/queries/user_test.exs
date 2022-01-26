defmodule GraphqlPracticeWeb.Schema.Queries.UserTest do
  use GraphqlPractice.DataCase, async: true
  alias GraphqlPractice.Accounts
  alias GraphqlPracticeWeb.Schema

  @user1_params %{name: "Ursula", email: "ursula@example.com"}
  @user2_params %{name: "Birgitta", email: "birgitta@example.com"}
  @user3_params %{name: "Harry", email: "harry@example.com"}

  @all_user_params [@user1_params, @user2_params, @user3_params]

  @user_doc """
    query getUser($id: ID){
      user(id: $id){
        id,
        name,
        email,
        uploads {
          title
          description
          id
        }
      }
    }
  """

  describe "@user" do
    test "Can get user by ID" do
      assert {:ok, user1} = Accounts.create_user(@user1_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_doc, Schema, variables: %{"id" => user1.id})

      assert %{"user" => %{"email" => "ursula@example.com", "name" => "Ursula"}} = data
    end
  end

  @user_by_name_doc """
    query getUserByName($name: String){
      userByName(name: $name){
        email,
        id,
        uploads{
          title,
          description,
          id
        }
      }
    }
  """

  describe "@user_by_name" do
    test "Can get user by their name" do
      assert {:ok, user1} = Accounts.create_user(@user1_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_by_name_doc, Schema, variables: %{"name" => user1.name})

      id = to_string(user1.id)

      assert %{"userByName" => %{"email" => "ursula@example.com", "id" => ^id, "uploads" => []}} =
               data
    end
  end

  @users_doc """
  query getUsers{
   users{
     id
     name
     email
     uploads {
       title
       description
       id
     }
   }
  }
  """

  describe "@users" do
    setup do
      start_supervised!({GraphqlPractice.Metric, self()})
      :ok
    end

    test "Returns a list of all users" do
      [%{id: user1_id}, %{id: user2_id}, %{id: user3_id}] =
        for params <- @all_user_params do
          assert {:ok, user} = Accounts.create_user(params)
          user
        end

      assert {:ok, %{data: data}} = Absinthe.run(@users_doc, Schema)

      assert %{"users" => users} = data

      user1_id = to_string(user1_id)
      user2_id = to_string(user2_id)
      user3_id = to_string(user3_id)

      assert [
               %{
                 "email" => "ursula@example.com",
                 "id" => ^user1_id,
                 "name" => "Ursula",
                 "uploads" => []
               },
               %{
                 "email" => "birgitta@example.com",
                 "id" => ^user2_id,
                 "name" => "Birgitta",
                 "uploads" => []
               },
               %{
                 "email" => "harry@example.com",
                 "id" => ^user3_id,
                 "name" => "Harry",
                 "uploads" => []
               }
             ] = Enum.sort_by(users, & &1["id"])
    end
  end
end
