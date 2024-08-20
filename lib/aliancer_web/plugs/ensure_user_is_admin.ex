defmodule AliancerWeb.Plugs.EnsureUserIsAdmin do
  use AliancerWeb, :controller

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: assigns} = conn, _opts) do
    if assigns.current_user.is_admin do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_flash(:error, "You must be an admin to access this page.")
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end
end
