defmodule Backend.Router do
  use Backend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :login do
    plug :accepts, ["json"]
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Backend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
  
  scope "/login", Backend do
    pipe_through :login
    
    post   "/", LoginController, :login
    delete "/", LoginController, :logout
  end

  scope "/api", Backend do
    pipe_through :api
    
    resources "/users", UserController, except: [:new, :edit]
    resources "/stuffs", StuffController, except: [:new, :edit]
  end
  
end
