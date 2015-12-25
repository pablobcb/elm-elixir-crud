defmodule Backend.LoginView do
  use Backend.Web, :view

  def render("login.json", %{user: user}) do
    %{id: user.id,
      username: user.username}
  end
end