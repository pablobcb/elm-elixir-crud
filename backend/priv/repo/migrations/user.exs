defmodule Backend.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users) do
      add :id,            primary_key: true
      add :username,      :string, size:200
      add :email,         :string, size:200
      add :hash,          :string, size:130
      add :recovery_hash, :string, size:130
      
      timestamps
    end
    
    create unique_index(:users, [:email])
  end
end