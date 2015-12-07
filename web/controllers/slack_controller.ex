defmodule Lunchify.SlackController do
  use Lunchify.Web, :controller

  alias Lunchify.Lunch

  def index(conn, %{"text" => "help" <> _rest}) do
    help = """
      /lunchify - Get a random lunch
      /lunchify help - This message
      /lunchify add <quote> - Add a lunch quote
      /lunchify count - Report on lunch count
    """
    conn
    |> json(%{text: help})
  end

  def index(conn, %{"text" => "count" <> _rest}) do
    q = from l in Lunch, select: count(l.id)
    cnt = Repo.one(q)
    conn
    |> json(%{
      response_type: "in_channel",
      # There can never be only one lunch, so we don't even account for that possibility
      text: "There are #{cnt} lunches available"
    })
  end

  def index(conn, %{"text" => "add " <> msg}) do
    changeset = Lunch.changeset(%Lunch{}, %{body: msg})

    case Repo.insert(changeset) do
      {:ok, _lunch} ->
        conn
        |> json(%{"text": "Lunch added"})
      {:error, changeset} ->
        conn
        |> json(%{"text": "There were errors with your lunch: " <> inspect(changeset.errors)})
    end
  end

  def index(conn, %{"text" => "find " <> id}) do
    lunch = Repo.get(Lunch, id)
    if is_nil(lunch) do
      conn
      |> json(%{"text": "No Lunch found with id #{id}"})
    else
      conn
      |> json(%{
          response_type: "in_channel",
          text: lunch.body
        })
    end

  end

  # Default is to return a random lunch
  def index(conn, _params) do
    :random.seed(:os.timestamp)
    lunch = Repo.all(Lunch) |> Enum.random
    conn
    |> json(%{
        response_type: "in_channel",
        text: lunch.body
      })
  end
end
