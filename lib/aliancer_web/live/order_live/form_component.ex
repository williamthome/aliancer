defmodule AliancerWeb.OrderLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Orders
  alias Aliancer.Persons

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage order records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="order-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:datetime]} type="datetime-local" label="Datetime" />
        <.input field={@form[:customer_id]} label="Customer" type="select" options={@customers} />
        <.input field={@form[:customer_pickup]} type="checkbox" label="Customer pickup" />
        <.input :if={@show_address} field={@form[:address]} type="textarea" label="Address" />
        <.input field={@form[:total]} type="number" label="Total" step="any" />
        <.input field={@form[:paid]} type="checkbox" label="Paid" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Aliancer.Orders.Order, :status)}
        />
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Order</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{order: order} = assigns, socket) do
    changeset = Orders.change_order(order)

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:form, fn -> to_form(changeset) end)
      |> assign_customers()
      |> assign_show_address(changeset)

    {:ok, socket}
  end

  defp assign_customers(socket) do
    customers =
      Persons.list_customers()
      |> Enum.map(&{&1.name, &1.id})

    assign(socket, :customers, customers)
  end

  defp assign_show_address(socket, %{changes: %{customer_pickup: true}}) do
    assign(socket, :show_address, false)
  end

  defp assign_show_address(socket, _changeset) do
    assign(socket, :show_address, true)
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset = Orders.change_order(socket.assigns.order, order_params)

    {:noreply,
     assign(socket, form: to_form(changeset, action: :validate))
     |> assign_show_address(changeset)}
  end

  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, socket.assigns.action, order_params)
  end

  defp save_order(socket, :edit, order_params) do
    case Orders.update_order(socket.assigns.order, order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, "Order updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_order(socket, :new, order_params) do
    case Orders.create_order(order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, "Order created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
