defmodule Lunchify.Router do
  use Lunchify.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lunchify do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/random_lunch", LunchController, :random_lunch
    resources "/lunches", LunchController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lunchify do
  #   pipe_through :api
  # end
end
