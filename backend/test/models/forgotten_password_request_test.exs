defmodule Backend.ForgottenPasswordRequestTest do
  use Backend.ModelCase

  alias Backend.ForgottenPasswordRequest
  
  @valid_attrs %{token: "de305d54-75b4-431b-adb2-eb6b9e546014", user_id: 10}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ForgottenPasswordRequest.changeset(%ForgottenPasswordRequest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ForgottenPasswordRequest.changeset(%ForgottenPasswordRequest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
