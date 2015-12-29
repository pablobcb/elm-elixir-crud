defmodule Backend.Repo.Migrations.CreateForgottenPasswordRequests do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:forgotten_password_requests, primary_key: false) do
      add :token, :string, primary_key: true
      add :user_id, references(:users)
      add :number_of_attempts, :integer, default: 0

      timestamps
    end

    create unique_index(:forgotten_password_requests, [:token]) 
    
  end
end
