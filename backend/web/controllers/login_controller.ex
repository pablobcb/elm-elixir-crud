defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  
  def login(conn, %{ "email" => email, "password" => password}) do
    case User |> Repo.get_by(email: email, password: password) do
      user when is_map(user) ->
      
        conn_ = conn
        |> Guardian.Plug.sign_in(user, :api)
        
        token = Guardian.Plug.current_token(conn_) 
        
        conn_ |> json %{ jwt: token }
        
      _ -> 
        conn
        |> put_status(:unauthorized)
        |> json %{ error: "invalid credentials" }
    end 
  end
  
  def logout(conn, _params) do
    case Guardian.Plug.claims(conn) do
      { :ok, claims } ->
        Guardian.Plug.sign_out(conn)
        |> send_resp(:no_content, "")
      
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json %{ "error" => "missing JWT in header" }
    end
  end
  
  def unauthenticated(conn, params) do
    conn
    |> put_status(:unauthorized)
    |> json %{ "error" => "missing JWT in header" }
  end
  
end