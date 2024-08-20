defmodule AliancerWeb.UserLive.Login do
  use AliancerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm pt-14">
      <.header class="text-center">
        <%= gettext("Log in to account") %>
        <%!--:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle--%>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label={gettext("Email")} required />
        <.input field={@form[:password]} type="password" label={gettext("Password")} required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label={gettext("Keep me logged in")} />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            <%= gettext("Forgot your password?") %>
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with={gettext("Logging in...")} class="w-full">
            <%= gettext("Log in") %> <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    socket =
      socket
      |> assign(:page_title, gettext("Login"))
      |> assign(:form, form)

    {:ok, socket, temporary_assigns: [form: form]}
  end
end
