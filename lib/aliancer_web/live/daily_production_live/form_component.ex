defmodule AliancerWeb.DailyProductionLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Products.DailyProduction

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage daily_production records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="daily_production-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="datetime-local" label="Date" />
        <.input field={@form[:quantity]} type="number" label="Quantity" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Daily production</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{daily_production: daily_production} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(DailyProduction.change_daily_production(daily_production))
     end)}
  end

  @impl true
  def handle_event("validate", %{"daily_production" => daily_production_params}, socket) do
    changeset = DailyProduction.change_daily_production(socket.assigns.daily_production, daily_production_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"daily_production" => daily_production_params}, socket) do
    save_daily_production(socket, socket.assigns.action, daily_production_params)
  end

  defp save_daily_production(socket, :edit, daily_production_params) do
    case DailyProduction.update_daily_production(socket.assigns.daily_production, daily_production_params) do
      {:ok, daily_production} ->
        notify_parent({:saved, daily_production})

        {:noreply,
         socket
         |> put_flash(:info, "Daily production updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_daily_production(socket, :new, daily_production_params) do
    case DailyProduction.create_daily_production(daily_production_params) do
      {:ok, daily_production} ->
        notify_parent({:saved, daily_production})

        {:noreply,
         socket
         |> put_flash(:info, "Daily production created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
