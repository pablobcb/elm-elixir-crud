defmodule Backend.ForgottenPasswordRequest do
  use Backend.Web, :model

  @primary_key {:token, :string, read_after_writes: true}
  schema "forgotten_password_requests" do
    field :created_at, Ecto.DateTime
    field :number_of_attempts, :integer
    belongs_to :users, Backend.User, foreign_key: :user_id
  end

  @required_fields ~w(token user_id)
  @optional_fields ~w(created_at number_of_attempts)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
