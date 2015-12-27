defmodule Backend.StuffControllerTest do
  use Backend.ConnCase

  alias Backend.Stuff
  alias Backend.User
  alias Backend.TestUtil
  
  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}
  
  setup %{conn: conn} do
    {:ok, conn: conn |> TestUtil.login_with_random_user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stuff_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    stuff = Repo.insert! %Stuff{}
    conn = get conn, stuff_path(conn, :show, stuff)
    assert json_response(conn, 200)["data"] == %{"id" => stuff.id,
      "title" => stuff.title,
      "content" => stuff.content}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, stuff_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, stuff_path(conn, :create), stuff: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Stuff, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stuff_path(conn, :create), stuff: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    stuff = Repo.insert! %Stuff{}
    conn = put conn, stuff_path(conn, :update, stuff), stuff: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Stuff, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    stuff = Repo.insert! %Stuff{}
    conn = put conn, stuff_path(conn, :update, stuff), stuff: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    stuff = Repo.insert! %Stuff{}
    conn = delete conn, stuff_path(conn, :delete, stuff)
    assert response(conn, 204)
    refute Repo.get(Stuff, stuff.id)
  end
end
