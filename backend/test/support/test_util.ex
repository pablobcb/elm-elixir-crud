import Backend.Router.Helpers

defmodule Backend.TestUtil do
  
  @endpoint Backend.Endpoint
  
  use Phoenix.ConnTest
  alias Backend.User
  alias Backend.Repo
  alias Backend.ForgottenPasswordRequest
  
  def random_user do
    %User{email: "brn@mgr.cafil", password: "brenoMagro", username: "bn"}
    |> Repo.insert!
  end
    
  defp create_user(conn) do
    conn 
    |> Map.put(:user, random_user())
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
  
  def create_forgot_password_request(conn) do
    token = Ecto.UUID.generate()
    
    changeset = ForgottenPasswordRequest.changeset(%ForgottenPasswordRequest{},
      %{ "user_id" => conn.user.id, "token" => token})
      
    Repo.insert!(changeset)
    
    conn
    |> Map.put(:forgot_password_token, token)
  end
end