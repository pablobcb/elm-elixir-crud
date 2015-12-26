defmodule Backend.LoginControllerTest do
  use Backend.ConnCase

  alias Backend.User
  
                            
  @invalid_attrs %{email: "craa@gordo", password: "streetGordo"}

                            
  setup %{conn: conn} do
    user = %User{email: "brn@mgr", password: "brenoMagro", username: "bn"}
      |> Repo.insert!
      
    token = authethicate(conn, user.email, user.password)
    
    {:ok, conn: conn
      |> Map.put(:user, user) 
      |> Map.put(:jwt, token) 
      |> put_req_header( "accept", "application/json")}
  end

  defp authethicate(conn, login, password) do
    conn = post conn, 
      login_path(conn, :login), 
      %{email: login, password: password}
      
    json_response(conn, 200)["jwt"] 
  end
  
  test "for 200 when POST /login with valid credentials", %{conn: conn} do
    token = authethicate(conn, conn.user.email, conn.user.password)
    
    assert token
    assert is_binary(token)
  end

  test "for 401 when POST /login with invalid credentials", %{conn: conn} do
    conn = post conn, login_path(conn, :login), @invalid_attrs
    assert json_response(conn, 401) == %{"error" => "invalid credentials"}
  end
  
  test "for 204 when DELETE /login with valid credentials", %{conn: conn} do
   conn = conn 
   |> put_req_header("authorization", "Bearer #{conn.jwt}")
   |> delete login_path(conn, :logout)
    
    assert json_response(conn, 204) == %{}
  end
  
  test "for 401 when DELETE /login with invalid credentials", %{conn: conn} do
    conn = conn 
    |> put_req_header("authorization", "Bearer Super Breno Magro")
    |> delete login_path(conn, :logout)
    
    assert json_response(conn, 401) == %{ "error" => "missing JWT in header" }
  end
end