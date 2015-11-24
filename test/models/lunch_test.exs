defmodule Lunchify.LunchTest do
  use Lunchify.ModelCase

  alias Lunchify.Lunch

  @valid_attrs %{body: "some content", tags: []}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @invalid_attrs)
    refute changeset.valid?
  end
end
