defmodule Backend.User do
  use Backend.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string
    field :activated_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(email password username)
  @optional_fields ~w(activated_at)

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
