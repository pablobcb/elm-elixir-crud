defmodule Backend.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users) do
      add :username, :string, size: 200
      add :email, :string, size: 200
      add :password, :string, size: 130
      add :activated_at, :datetime, default: nil
      
      timestamps
    end
    
    create unique_index(:users, [:email]) 
  end
  
end
