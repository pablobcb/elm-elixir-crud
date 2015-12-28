defmodule Backend.ForgottenPasswordRequestView do
  use Backend.Web, :view

  def render("index.json", %{forgotten_password_request: forgotten_password_request}) do
    %{data: render_many(forgotten_password_request, Backend.ForgottenPasswordRequestView, "forgotten_password_request.json")}
  end

  def render("show.json", %{forgotten_password_request: forgotten_password_request}) do
    %{data: render_one(forgotten_password_request, Backend.ForgottenPasswordRequestView, "forgotten_password_request.json")}
  end

  def render("forgotten_password_request.json", %{forgotten_password_request: forgotten_password_request}) do
    %{id: forgotten_password_request.id}
  end
end
