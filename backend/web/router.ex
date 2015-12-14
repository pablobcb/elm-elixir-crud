defmodule Backend.Router do
  use Backend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Backend do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController

    get "/", PageController, :index
  end

  scope "/api", Backend do
    pipe_through :api

    resources "/games", GameController
  end
end
