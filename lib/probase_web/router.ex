defmodule ProbaseWeb.Router do
  use ProbaseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ProbaseWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(ProbaseWeb.Plugs.SetUser)
    plug(ProbaseWeb.Plugs.SessionTimeout, timeout_after_seconds: 3_600)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :session do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end


  pipeline :no_layout do
    plug :put_layout, false
  end

  
  scope "/", ProbaseWeb do
    pipe_through([:session, :no_layout])

    get("/", SessionController, :new)
    post("/", SessionController, :create)
    get("/forgort/password", UserController, :forgot_password)
    post("/confirmation/token", UserController, :token)
    get("/reset/password", UserController, :default_password)
  end

  scope "/", ProbaseWeb do
    pipe_through([:browser, :no_layout])

    get("/create/new/password", UserController, :change_password)
    post("/create/new/password", UserController, :change_password)
    get("/new/password", UserController, :new_password)
    post("/new/password", UserController, :new_password)
    get "/chats", UserController, :index
    get "/show/:id", UserController, :show
    post "/show/:id", UserController, :file_uploads
    get "/forums_func/create", UserController, :forums_func
    post "/forums_func/create", UserController, :forums_func
 
  end

  scope "/", ProbaseWeb do
    pipe_through :browser
    get("/dashboard", UserController, :dashboard)
    get("/profile/user", UserController, :profile)
    post("/profile/user/upload", UserController, :upload_profile)
    get "/create/add/announcement", UserController, :announce
    post "/create/add/announcement", UserController, :announce
    get "/view/check_announce", NotifyController, :check_announce
    get "/announ/view/:id", NotifyController, :announ_view
    get "/previous_ann/view/", NotifyController, :previous_ann
    post "/announ/view/:id", NotifyController, :notify_uploads
    get "/search/search_query", UserController, :search_query
    post "/search/search_query", UserController, :search_query
    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProbaseWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ProbaseWeb.Telemetry
    end
  end
end
