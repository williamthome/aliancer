defmodule AliancerWeb.Router do
  use AliancerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AliancerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AliancerWeb do
    pipe_through :browser

    live "/", DashboardLive.Index, :index
    live "/dashboard", DashboardLive.Index, :index

    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Index, :new
    live "/products/:id/edit", ProductLive.Index, :edit

    live "/products/:id", ProductLive.Show, :show
    live "/products/:id/show/edit", ProductLive.Show, :edit

    live "/daily_production", DailyProductionLive.Index, :index
    live "/daily_production/new", DailyProductionLive.Index, :new
    live "/daily_production/:id/edit", DailyProductionLive.Index, :edit

    live "/daily_production/:id", DailyProductionLive.Show, :show
    live "/daily_production/:id/show/edit", DailyProductionLive.Show, :edit

    live "/customers", CustomerLive.Index, :index
    live "/customers/new", CustomerLive.Index, :new
    live "/customers/:id/edit", CustomerLive.Index, :edit

    live "/customers/:id", CustomerLive.Show, :show
    live "/customers/:id/show/edit", CustomerLive.Show, :edit

    live "/orders", OrderLive.Index, :index
    live "/orders/new", OrderLive.Index, :new
    live "/orders/:id/edit", OrderLive.Index, :edit

    live "/orders/:id", OrderLive.Show, :show
    live "/orders/:id/show/edit", OrderLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AliancerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:aliancer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AliancerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
