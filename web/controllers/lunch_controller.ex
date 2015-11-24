defmodule Lunchify.LunchController do
  use Lunchify.Web, :controller

  alias Lunchify.Lunch

  plug :scrub_params, "lunch" when action in [:create, :update]

  def random_lunch(conn, _params) do
    lunch = Repo.all(Lunch) |> Enum.random
    json(conn, %{
      repsonse_type: "in_channel",
      text: lunch.body
      })
  end

  def index(conn, _params) do
    lunches = Repo.all(Lunch)
    render(conn, "index.html", lunches: lunches)
  end

  def new(conn, _params) do
    changeset = Lunch.changeset(%Lunch{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lunch" => lunch_params}) do
    changeset = Lunch.changeset(%Lunch{}, lunch_params)

    case Repo.insert(changeset) do
      {:ok, _lunch} ->
        conn
        |> put_flash(:info, "Lunch created successfully.")
        |> redirect(to: lunch_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)
    render(conn, "show.html", lunch: lunch)
  end

  def edit(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)
    changeset = Lunch.changeset(lunch)
    render(conn, "edit.html", lunch: lunch, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lunch" => lunch_params}) do
    lunch = Repo.get!(Lunch, id)
    changeset = Lunch.changeset(lunch, lunch_params)

    case Repo.update(changeset) do
      {:ok, lunch} ->
        conn
        |> put_flash(:info, "Lunch updated successfully.")
        |> redirect(to: lunch_path(conn, :show, lunch))
      {:error, changeset} ->
        render(conn, "edit.html", lunch: lunch, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(lunch)

    conn
    |> put_flash(:info, "Lunch deleted successfully.")
    |> redirect(to: lunch_path(conn, :index))
  end
end
