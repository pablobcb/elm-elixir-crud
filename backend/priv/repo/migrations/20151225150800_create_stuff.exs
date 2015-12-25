defmodule Backend.Repo.Migrations.CreateStuff do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:stuffs) do
      add :title, :string
      add :content, :string

      timestamps
    end

  end
end
