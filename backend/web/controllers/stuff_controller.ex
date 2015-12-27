defmodule Backend.StuffController do
  use Backend.Web, :controller

  alias Backend.Stuff

  plug :scrub_params, "stuff" when action in [:create, :update]

  def index(conn, _params) do
    stuffs = Repo.all(Stuff)
    render(conn, "index.json", stuffs: stuffs)
  end

  def create(conn, %{"stuff" => stuff_params}) do
    changeset = Stuff.changeset(%Stuff{}, stuff_params)

    case Repo.insert(changeset) do
      {:ok, stuff} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", stuff_path(conn, :show, stuff))
        |> render("show.json", stuff: stuff)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Backend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stuff = Repo.get!(Stuff, id)
    render(conn, "show.json", stuff: stuff)
  end

  def update(conn, %{"id" => id, "stuff" => stuff_params}) do
    stuff = Repo.get!(Stuff, id)
    changeset = Stuff.changeset(stuff, stuff_params)

    case Repo.update(changeset) do
      {:ok, stuff} ->
        render(conn, "show.json", stuff: stuff)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Backend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stuff = Repo.get!(Stuff, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(stuff)

    send_resp(conn, :no_content, "")
  end
end
