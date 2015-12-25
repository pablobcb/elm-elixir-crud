defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  
  def login(conn, %{ "email" => email, "password" => password}) do
  
      case User |> Repo.get_by(email: email, password: password) do
        user when is_map(user) -> 
          conn
          |> put_status(:created)
          |> render("login.json", user: user)
          
        _ -> 
          conn
          |> put_status(:unauthorized)
          |> json %{}
      end 
    
  end
  
end