defmodule Backend.StuffView do
  use Backend.Web, :view

  def render("index.json", %{stuffs: stuffs}) do
    %{data: render_many(stuffs, Backend.StuffView, "stuff.json")}
  end

  def render("show.json", %{stuff: stuff}) do
    %{data: render_one(stuff, Backend.StuffView, "stuff.json")}
  end

  def render("stuff.json", %{stuff: stuff}) do
    %{id: stuff.id,
      title: stuff.title,
      content: stuff.content}
  end
end
