defmodule Backend.GameView do
  use Backend.Web, :view

  def render("index.json", %{game: game}) do
    %{games: render_many(game, Backend.GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{game: render_one(game, Backend.GameView, "game.json") }
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      title: game.title}
  end
end
