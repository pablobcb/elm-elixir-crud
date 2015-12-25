defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  
  def login(conn, %{ "email" => email, "password" => password}) do
    case User |> Repo.get_by(email: email, password: password) do
      user when is_map(user) ->
     
        case Guardian.encode_and_sign(user, :api) do
          { :ok, jwt, _ } ->
            conn
            |> json %{jwt: jwt}
            
          { :error, reason } ->
            IO.inspect reason
            conn
            |> json %{ error: "error generating JWT token" }
        end
        
      _ -> 
        conn
        |> put_status(:unauthorized)
        |> json %{}
    end 
  end
  
   def logout(conn, _params) do
    case Guardian.Plug.claims(conn) do
      { :error, reason } ->
        conn
        |> put_status(:unauthorized)
        |> json %{ error: reason }
      
      _ -> 
        conn
        |> json %{ error: "Login required" }
    end
  end
  
end