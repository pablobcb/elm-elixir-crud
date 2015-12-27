defmodule Backend.LoginControllerTest do
  use Backend.ConnCase

  alias Backend.User
  
                            
  @invalid_attrs %{email: "craa@gordo", password: "streetGordo"}

                            
  def create_user(conn) do
    user = %User{email: "brn@mgr", password: "brenoMagro", username: "bn"}
    |> Repo.insert!
      
    conn 
    |> Map.put(:user, user)
  end
  
  def authethicate(conn) do
    conn = post conn, 
      login_path(conn, :login), 
      %{email: conn.user.email, password: conn.user.password}
      
    conn() 
    |> Map.put(:jwt, json_response(conn, 200)["jwt"])
  end
  
  setup %{conn: conn} do
    {:ok, conn: conn
      |> create_user
      |> put_req_header( "accept", "application/json")
      |> authethicate}
      
  end
  
  
  test "for 200 when POST /login with valid credentials", %{conn: conn} do
    assert conn.jwt
    assert conn.jwt |> is_binary
  end

  test "for 401 when POST /login with invalid credentials", %{conn: conn} do
    conn = post conn, login_path(conn, :login), @invalid_attrs
    assert json_response(conn, 401) == %{"error" => "invalid credentials"}
  end
  
  test "for 204 when DELETE /login with valid credentials", %{conn: conn} do
    conn = conn()
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