defmodule Backend.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :title, :string

      timestamps
    end

  end
end
