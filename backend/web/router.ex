defmodule Backend.Router do
  use Backend.Web, :router

  pipeline :open do
    plug :accepts, ["json"]
    plug :fetch_session
  end
  
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Backend.LoginController
  end

  scope "/", Backend do
    pipe_through :open
    
    post "/token", LoginController, :login
    post "/user", UserController, :create
  end

  scope "/api", Backend do
    pipe_through :api
    
    delete "/token", LoginController, :logout
    
    resources "/users", UserController, except: [:new, :edit, :create]
    resources "/stuffs", StuffController, except: [:new, :edit]
  end
  
end
