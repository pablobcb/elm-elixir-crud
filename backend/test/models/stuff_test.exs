defmodule Backend.StuffTest do
  use Backend.ModelCase

  alias Backend.Stuff

  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Stuff.changeset(%Stuff{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Stuff.changeset(%Stuff{}, @invalid_attrs)
    refute changeset.valid?
  end
end
