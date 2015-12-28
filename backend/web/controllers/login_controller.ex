defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  alias Backend.ForgottenPasswordRequest
  
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
  
  
  def forgot_password(conn, %{ "email" => email}) do
    case User |> Repo.get_by(email: email) do
      user when is_map(user) ->
        #remove all previous forgotten password requests
        from(r in ForgottenPasswordRequests, where: r.user_id == ^user.id )
        |> Repo.delete_all
        
        #generate token
        token = SecureRandom.uuid
        
        #persist token
        params = %{ "user_id" => user.id, "token" => token}
        
        changeset = ForgottenPasswordRequest.changeset(
          %ForgottenPasswordRequest{}, params)

        case Repo.insert(changeset) do
          {:ok, forgotten_password_requests} ->
            conn |> send_resp 200, "Ok"
            
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json %{ error: "oops! something went wrong on our server" }
        end
        
        
      _ -> 
        conn
        |> put_status(:unprocessable_entity)
        |> json %{ error: "email not found" }
    end
  end
end