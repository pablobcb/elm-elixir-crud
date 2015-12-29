
defmodule Backend.ForgottenPasswordControllerTest do
  use Backend.ConnCase
  
  alias Backend.TestUtil
  alias Backend.ForgottenPasswordRequest
  alias Backend.User
  
  setup %{conn: conn} do
    conn_ = conn
    |> TestUtil.login_with_random_user
    
    {:ok, conn: conn_
    |> TestUtil.create_forgot_password_request}
  end
  
  
  test "for 201 when POST /forgot-password with valid email", %{conn: conn} do
    conn = conn
    |> post forgotten_password_path(conn, :create_forgot_password_request), %{"email" => conn.user.email}
    
    assert response(conn, 201) == ""
  end
  
  test "for 404 when POST /forgot-password with invalid email", %{conn: conn} do
    conn = conn
    |> post forgotten_password_path(conn, :create_forgot_password_request), %{"email" => "street@craa.com"}
    
    assert json_response(conn, 404) == %{"error" => "email not found"}
    
  end
  
  test "for 201 when GET /forgot-password with valid link", %{conn: conn} do
    
    conn = conn
    |> get "/password-reset/#{conn.forgot_password_token}"
    
    assert response(conn, 200) == ""
    
  end
  
  test "for 404 when GET /forgot-password with invalid link", %{conn: conn} do
    conn = conn
    |> get "/password-reset/de305d54-75b4-431b-adb2-eb6b9e546014"
    
    assert json_response(conn, 404) == %{"error" => "token not found"}
  end
  
  test "validates token and user password for password reset" , %{conn: conn} do
    new_password = "new_password"
    conn = put conn, forgotten_password_path(conn, :reset_password),  
      %{ "forgot_password_token" => conn.forgot_password_token, 
        "new_password" => new_password }
      
    assert json_response(conn, 200)["jwt"] |> is_binary
    assert Repo.get_by(User, password: new_password)
    refute Repo.get_by(ForgottenPasswordRequest,
      token: conn.forgot_password_token)
  end
end