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

  defp assign_current_uri(_params, url, socket) do
    {:cont, Phoenix.Component.assign(socket, :current_uri, URI.parse(url) |> Map.get(:path))}
  end
end
