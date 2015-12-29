defmodule Backend.LoginController do
  use Backend.Web, :controller

  alias Backend.User
  alias Backend.ForgottenPasswordRequest
  
  def login(conn, %{ "email" => email, "password" => password}) do
    case User |> Repo.get_by(email: email, password: password) do
    
      user when is_map(user) ->
        conn_ = conn
        |> Guardian.Plug.sign_in(user, :api)
        
        jwt_token = Guardian.Plug.current_token(conn_)
        
        conn_ 
        |> json %{ jwt: jwt_token }
        
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
  
  def validate_link(conn,  %{"token" => token}) do
    now = Ecto.DateTime.utc(:usec)
    result =  Repo.one(
      from r in ForgottenPasswordRequest,
      where: r.inserted_at < ^now and r.token == ^token,
      #where: (^now - r.inserted_at) < 30  and r.token == ^token,
      select: r)
      
    case result do 
      forgotten_password_request when is_map(forgotten_password_request) ->
        conn |> send_resp(200, "")
      
      _ -> 
        conn
        |> put_status(:not_found)
        |> json %{ error: "token not found" }
        
    end
  end
  
end