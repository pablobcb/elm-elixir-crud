defmodule Backend.UserView do
  use Backend.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Backend.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Backend.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      password: user.password,
      username: user.username}
  end
end
