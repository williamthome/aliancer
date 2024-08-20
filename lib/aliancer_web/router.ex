defmodule AliancerWeb.Router do
  use AliancerWeb, :router

  import AliancerWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AliancerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", AliancerWeb do
    pipe_through [:browser, AliancerWeb.Plugs.EnsureUserIsAdmin]

    live_dashboard "/dev/dashboard", metrics: AliancerWeb.Telemetry
    forward "/dev/mailbox", Plug.Swoosh.MailboxPreview

    live_session :ensure_user_is_admin,
      on_mount: [
        {AliancerWeb.UserAuth, :ensure_user_is_admin},
        {AliancerWeb.Hooks.Assign, :current_uri}
      ] do
    end
  end

  scope "/", AliancerWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{AliancerWeb.UserAuth, :mount_current_user}],
      layout: {AliancerWeb.Layouts, :guest} do
      live "/users/confirm/:token", UserLive.Confirmation, :edit
      live "/users/confirm", UserLive.ConfirmationInstructions, :new
    end

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", AliancerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{AliancerWeb.UserAuth, :redirect_if_user_is_authenticated}],
      layout: {AliancerWeb.Layouts, :guest} do
      live "/users/register", UserLive.Registration, :new
      live "/users/log_in", UserLive.Login, :new
      live "/users/reset_password", UserLive.ForgotPassword, :new
      live "/users/reset_password/:token", UserLive.ResetPassword, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", AliancerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {AliancerWeb.UserAuth, :ensure_authenticated},
        {AliancerWeb.Hooks.Assign, :current_uri}
      ] do
      live "/", DashboardLive.Index, :index

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

      live "/employees", EmployeeLive.Index, :index
      live "/employees/new", EmployeeLive.Index, :new
      live "/employees/:id/edit", EmployeeLive.Index, :edit

      live "/employees/:id", EmployeeLive.Show, :show
      live "/employees/:id/show/edit", EmployeeLive.Show, :edit

      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm_email/:token", UserLive.Settings, :confirm_email
    end
  end
end
