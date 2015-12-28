defmodule Backend.ForgottenPasswordRequest do
  use Backend.Web, :model

  schema "forgotten_password_request" do
    field :token, :string
    field :created_at, Ecto.DateTime
    belongs_to :users, Backend.User, foreign_key: :user_id
    

  end

  @required_fields ~w(token user_id)
  @optional_fields ~w(created_at)

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
