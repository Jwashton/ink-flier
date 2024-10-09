defmodule InkFlierWeb.Router do
  use InkFlierWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {InkFlierWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :game do
    plug :put_root_layout, html: {InkFlierWeb.GameLayouts, :root}
  end

  pipeline :user do
    plug :browser
    plug InkFlierWeb.Plugs.AssignUser
  end

  pipeline :login_required do
    plug :browser
    plug InkFlierWeb.Plugs.LoginRequired
  end


  scope "/", InkFlierWeb do
    pipe_through :user

    get "/", PageController, :home

    get "/login", LoginController, :new
    post "/login", LoginController, :create
    get "/logout", LoginController, :delete
  end

  scope "/", InkFlierWeb do
    pipe_through :login_required

    get "/lobby", LobbyController, :home
  end

  scope "/game", InkFlierWeb do
    pipe_through [:browser, :game]

    get "/sandbox", GameController, :sandbox
  end


  # Other scopes may use custom stacks.
  # scope "/api", InkFlierWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ink_flier, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InkFlierWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
