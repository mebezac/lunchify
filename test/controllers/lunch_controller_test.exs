defmodule Lunchify.LunchControllerTest do
  use Lunchify.ConnCase

  alias Lunchify.Lunch
  @valid_attrs %{body: "some content", tags: []}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, lunch_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing lunches"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, lunch_path(conn, :new)
    assert html_response(conn, 200) =~ "New lunch"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, lunch_path(conn, :create), lunch: @valid_attrs
    assert redirected_to(conn) == lunch_path(conn, :index)
    assert Repo.get_by(Lunch, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, lunch_path(conn, :create), lunch: @invalid_attrs
    assert html_response(conn, 200) =~ "New lunch"
  end

  test "shows chosen resource", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = get conn, lunch_path(conn, :show, lunch)
    assert html_response(conn, 200) =~ "Show lunch"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, lunch_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = get conn, lunch_path(conn, :edit, lunch)
    assert html_response(conn, 200) =~ "Edit lunch"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = put conn, lunch_path(conn, :update, lunch), lunch: @valid_attrs
    assert redirected_to(conn) == lunch_path(conn, :show, lunch)
    assert Repo.get_by(Lunch, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = put conn, lunch_path(conn, :update, lunch), lunch: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit lunch"
  end

  test "deletes chosen resource", %{conn: conn} do
    lunch = Repo.insert! %Lunch{}
    conn = delete conn, lunch_path(conn, :delete, lunch)
    assert redirected_to(conn) == lunch_path(conn, :index)
    refute Repo.get(Lunch, lunch.id)
  end
end
