defmodule AliancerWeb.OrderLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Orders
  alias Aliancer.Persons
  alias Aliancer.Products

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= gettext("Use this form to manage order records in your database.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="order-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.tabs>
          <:tab slug="info" label={gettext("Details")} class="pt-8 space-y-8" active>
            <.input
              field={@form[:customer_id]}
              label={gettext("Customer")}
              type="select"
              prompt={gettext("Choose a value")}
              options={@customers}
            />
            <.input
              field={@form[:status]}
              type="select"
              label={gettext("Status")}
              options={Aliancer.Orders.Order.statuses_select_options()}
            />
            <.input field={@form[:datetime]} type="datetime-local" label={gettext("Datetime")} />
            <.input field={@form[:notes]} type="textarea" label={gettext("Notes")} />
          </:tab>
          <:tab slug="items" label={gettext("Items")} class="pt-8 space-y-8">
            <.header>
              <%= gettext("Listing Items") %>
              <:actions>
                <label class="rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 cursor-pointer">
                  <input type="checkbox" name="order[items_order][]" class="hidden" />
                  <span><%= gettext("Add Item") %></span>
                </label>
              </:actions>
            </.header>

            <div class="space-y-2">
              <.inputs_for :let={item_form} field={@form[:items]}>
                <input type="hidden" name="order[items_order][]" value={item_form.index} />
                <div class="flex space-x-2">
                  <.input
                    field={item_form[:product_id]}
                    label={if item_form.index == 0, do: gettext("Item")}
                    type="select"
                    options={@products}
                    control_class="grow"
                  />
                  <.input
                    field={item_form[:quantity]}
                    type="number"
                    label={if item_form.index == 0, do: gettext("Quantity")}
                    step="any"
                  />
                  <.input
                    field={item_form[:total]}
                    type="number"
                    label={if item_form.index == 0, do: gettext("Total")}
                    step="any"
                  />
                  <div class="flex flex-col">
                    <label
                      :if={item_form.index == 0}
                      class="block text-sm font-semibold leading-6 text-zinc-800 invisible"
                    >
                      X
                    </label>
                    <label class="mt-2 flex items-center justify-center grow cursor-pointer">
                      <input
                        type="checkbox"
                        name="order[items_delete][]"
                        value={item_form.index}
                        class="hidden"
                      />
                      <.icon name="hero-x-mark" />
                    </label>
                  </div>
                </div>
              </.inputs_for>

              <div
                :if={!is_list(@form[:items].value) || @form[:items].value == []}
                class="text-center px-3 py-5 border"
              >
                <.header>
                  <%= gettext("Nothing!") %>
                  <:subtitle>
                    <%= gettext("Please add the order items") %>
                  </:subtitle>
                </.header>
              </div>
            </div>
            <.input field={@form[:total]} type="number" label={gettext("Total")} step="any" />
            <.input field={@form[:paid]} type="checkbox" label={gettext("Paid")} />
          </:tab>
          <:tab slug="address" label={gettext("Address")} class="pt-8 space-y-8">
            <div class="flex items-center justify-between">
              <.input
                field={@form[:customer_pickup]}
                type="checkbox"
                label={gettext("Customer pickup")}
              />
              <.button
                :if={@form[:customer_id].value && @form[:customer_pickup].value not in [true, "true"]}
                type="button"
                phx-target={@myself}
                phx-click="copy_customer_address"
              >
                Copy customer address
              </.button>
            </div>
            <div :if={@form[:customer_pickup].value not in [true, "true"]} class="space-y-8">
              <.input field={@form[:addr_street]} type="text" label={gettext("Street name")} />
              <.input field={@form[:addr_number]} type="text" label={gettext("Street number")} />
              <.input field={@form[:addr_complement]} type="text" label={gettext("Complement")} />
              <.input field={@form[:addr_neighborhood]} type="text" label={gettext("Neighborhood")} />
              <.input field={@form[:addr_state]} type="text" label={gettext("State")} />
              <.input field={@form[:addr_city]} type="text" label={gettext("City")} />
              <.input field={@form[:addr_postcode]} type="text" label={gettext("Postal code")} />
              <.input field={@form[:addr_reference]} type="textarea" label={gettext("Reference")} />
            </div>
          </:tab>
        </.tabs>

        <:actions>
          <.button phx-disable-with={gettext("Saving...")}>
            <%= gettext("Save Order") %>
          </.button>
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
      |> assign_products()

    {:ok, socket}
  end

  defp assign_customers(socket) do
    customers =
      Persons.list_customers()
      |> Enum.map(&{&1.first_name, &1.id})

    assign(socket, :customers, customers)
  end

  defp assign_products(socket) do
    products =
      Products.list_saleable_products()
      |> Enum.map(&{&1.name, &1.id})

    assign(socket, :products, products)
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset = Orders.change_order(socket.assigns.order, order_params)

    socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("copy_customer_address", _params, socket) do
    customer = socket.assigns.order.customer

    order_params =
      Map.take(customer, [
        :addr_street,
        :addr_number,
        :addr_complement,
        :addr_neighborhood,
        :addr_city,
        :addr_state,
        :addr_postcode,
        :addr_reference
      ])

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.change(order_params)

    socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))

    {:noreply, socket}
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
         |> put_flash(:info, gettext("Order updated successfully"))
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
         |> put_flash(:info, gettext("Order created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
