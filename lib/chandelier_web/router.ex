defmodule ChandelierWeb.Router do
  use ChandelierWeb, :router

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

  scope "/", ChandelierWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ChandelierWeb do
    pipe_through :api
    post "/switch", SwitchController, :switch
    post "/switch_all", SwitchController, :switch_all
  end
end
