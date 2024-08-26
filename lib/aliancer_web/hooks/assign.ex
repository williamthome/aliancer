defmodule AliancerWeb.Hooks.Assign do
  def on_mount(:current_uri, _params, _session, socket) do
    {:cont,
     Phoenix.LiveView.attach_hook(
       socket,
       :save_request_path,
       :handle_params,
       &assign_current_uri/3
     )}
  end

  def on_mount(:show_menu, _params, _session, socket) do
    # Tests do not contain :user_agent
    show_menu =
      case Phoenix.LiveView.get_connect_info(socket, :user_agent) do
        nil ->
          true

        ua ->
          Browser.device_type(ua) == :desktop
      end

    socket =
      socket
      |> Phoenix.Component.assign(:show_menu, show_menu)

    {:cont, socket}
  end

  defp assign_current_uri(_params, url, socket) do
    {:cont, Phoenix.Component.assign(socket, :current_uri, URI.parse(url) |> Map.get(:path))}
  end
end
