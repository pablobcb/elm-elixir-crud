defmodule Backend.ForgottenPasswordController do
  use Backend.Web, :controller

  alias Backend.User
  alias Backend.ForgottenPasswordRequest
  
  defp validate_token_ (token) do
    now = Ecto.DateTime.utc()
    Repo.one(
      from r in ForgottenPasswordRequest,
      #TODO: put -30 in constant
      where: datetime_add(^now, -30, "day") < r.inserted_at 
      and r.token == ^token, 
      select: r
    )
  end
  
  def validate_token(conn,  %{"token" => token}) do
    case validate_token_(token) do 
      forgotten_password_request when is_map(forgotten_password_request) ->
        conn |> send_resp(200, "")
      
      _ -> 
        conn
        |> put_status(:not_found)
        |> json %{ error: "token not found" }
        
    end
  end
  
  
  def create_forgot_password_request(conn, %{ "email" => email }) do
    case User |> Repo.get_by(email: email) do
      user when is_map(user) ->
        #remove all previous forgotten password requests
        from(r in ForgottenPasswordRequest, where: r.user_id == ^user.id )
        |> Repo.delete_all
        
        changeset = ForgottenPasswordRequest.changeset(%ForgottenPasswordRequest{},
          %{ "user_id" => user.id, "token" => Ecto.UUID.generate()})
          
        case Repo.insert(changeset) do
          {:ok, forgotten_password_request} ->
            conn |> send_resp 201, ""
            
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json %{ error: "oops! something went wrong on our server" }
            
        end
        
      _ -> 
        conn
        |> put_status(:not_found)
        |> json %{ error: "email not found" }
    end
  end
  
  
  def reset_password(conn, 
    %{"new_password" => new_password, "forgot_password_token" => token}) do
    
    case validate_token_(token) do 
      forgotten_password_request when is_map(forgotten_password_request) ->
        user = Repo.get!(User, forgotten_password_request.user_id)
        changeset = User.changeset(user,  %{ "password" => new_password })
        
        case Repo.update(changeset) do
          {:ok, user} ->
            from(r in ForgottenPasswordRequest, 
            where: r.token == ^token)
            |> Repo.delete_all
            
            conn_ = conn
            |> Guardian.Plug.sign_in(user, :api)
          
            conn_ 
            |> json %{ jwt: Guardian.Plug.current_token(conn_) }
            
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Backend.ChangesetView, "error.json", changeset: changeset)
        end
      
      _ -> 
        conn
        |> put_status(:unauthorized)
        |> json %{ error: "token not found" }
        
    end
    
  end
  
end