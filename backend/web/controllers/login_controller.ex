defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  #TODO usar session
  def login(conn, %{ "email" => email, "password" => password}) do
    case User |> Repo.get_by(email: email, password: password) do
      user when is_map(user) ->
      
        resp_body = case Guardian.encode_and_sign(user, :api) do
          { :ok, jwt, claims } ->
            %{ jwt: jwt }
            
          { :error, reason } ->
            %{ error: "error generating JWT token" }
        end
        
        conn |> json resp_body
        
      _ -> 
        conn
        |> put_status(:unauthorized)
        |> json %{ error: "invalid credentials" }
    end 
  end
  
  def logout(conn, _params) do
    #IO.inspect Guardian.Plug.current_token(conn)
    IO.inspect Guardian.Plug.claims(conn)
    case Guardian.Plug.claims(conn) do
      { :ok, claims } ->
        Guardian.revoke!(Guardian.Plug.current_token(conn), claims)
        conn
        |> put_status(:no_content)
        |> json %{}
      
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json %{ "error" => "missing JWT in header" }
    end
  end
  
end