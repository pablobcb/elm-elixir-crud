import Backend.Router.Helpers

defmodule Backend.TestUtil do
  
  @endpoint Backend.Endpoint
  
  use Phoenix.ConnTest
  alias Backend.User
  alias Backend.Repo
  
  defp create_user(conn) do
    user = %User{email: "brn@mgr", password: "brenoMagro", username: "bn"}
    |> Repo.insert!
      
    conn 
    |> Map.put(:user, user)
  end
  
  defp authethicate(conn) do
    conn = post conn, 
      login_path(conn, :login), 
      %{email: conn.user.email, password: conn.user.password}
     
    token = json_response(conn, 200)["jwt"]
      
    conn() 
    |> Map.put(:user, conn.user)
    |> Map.put(:jwt, token)
    |> put_req_header("authorization", "Bearer #{token}")
  end
  
  def login_with_random_user(conn) do
    conn
    |> put_req_header( "accept", "application/json")
    |> create_user
    |> authethicate
  end
end