defmodule Lunchify.SlackControllerTest do
  use Lunchify.ConnCase

  alias Lunchify.Lunch
  @lunch_text "To lunch or not to lunch"

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "displays help", %{conn: conn} do
    conn = get conn, slack_path(conn, :index), %{text: "help"}
    %{"text" => text} = json_response(conn, 200)
    assert text =~ "This message"
  end

  test "displays count", %{conn: conn} do
    Repo.insert(%Lunch{body: "First lunch"})
    Repo.insert(%Lunch{body: "Second lunch"})

    conn = get conn, slack_path(conn, :index), %{text: "count"}
    %{"text" => text} = json_response(conn, 200)
    assert text =~ "2 lunches available"
  end

  test "add a new lunch", %{conn: conn} do
    refute Repo.get_by(Lunch, body: @lunch_text)
    conn = get conn, slack_path(conn, :index), %{text: "add " <> @lunch_text}
    %{"text" => text} = json_response(conn, 200)
    assert text == "Lunch added"
    assert Repo.get_by(Lunch, body: @lunch_text)
  end

  test "returns a random lunch", %{conn: conn} do
    Repo.insert(%Lunch{body: "First lunch"})
    Repo.insert(%Lunch{body: "Second lunch"})

    conn = get conn, slack_path(conn, :index)
    %{"text" => text} = json_response(conn, 200)
    assert text =~ "lunch"
  end
end
