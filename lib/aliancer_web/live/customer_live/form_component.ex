defmodule AliancerWeb.CustomerLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Persons

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= gettext("Use this form to manage customer records in your database.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="customer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.tabs>
          <:tab slug="info" label={gettext("Details")} class="pt-8 space-y-8" active>
            <.input
              field={@form[:person_type]}
              type="select"
              label={gettext("Person type")}
              options={Aliancer.Persons.Customer.person_type_select_options()}
            />
            <.input
              field={@form[:name]}
              type="text"
              label={Aliancer.Persons.Customer.first_name_label(@form[:person_type].value)}
            />
            <.input
              field={@form[:second_name]}
              type="text"
              label={Aliancer.Persons.Customer.second_name_label(@form[:person_type].value)}
            />
            <.input
              field={@form[:id_number]}
              type="text"
              label={Aliancer.Persons.Customer.id_number_label(@form[:person_type].value)}
            />
            <.input field={@form[:notes]} type="textarea" label={gettext("Notes")} />
          </:tab>
          <:tab slug="contact" label={gettext("Contact")} class="pt-8 space-y-8">
            <.input field={@form[:contact_phone]} type="text" label={gettext("Phone")} />
            <.input field={@form[:contact_email]} type="text" label={gettext("Email")} />
          </:tab>
          <:tab slug="address" label={gettext("Address")} class="pt-8 space-y-8">
            <.input field={@form[:addr_street]} type="text" label={gettext("Street name")} />
            <.input field={@form[:addr_number]} type="text" label={gettext("Street number")} />
            <.input field={@form[:addr_complement]} type="text" label={gettext("Complement")} />
            <.input field={@form[:addr_neighborhood]} type="text" label={gettext("Neighborhood")} />
            <.input field={@form[:addr_state]} type="text" label={gettext("State")} />
            <.input field={@form[:addr_city]} type="text" label={gettext("City")} />
            <.input field={@form[:addr_postcode]} type="text" label={gettext("Postal code")} />
            <.input field={@form[:addr_reference]} type="textarea" label={gettext("Reference")} />
          </:tab>
        </.tabs>

        <:actions>
          <.button phx-disable-with={gettext("Saving...")}>
            <%= gettext("Save Customer") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{customer: customer} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Persons.change_customer(customer))
     end)}
  end

  @impl true
  def handle_event("validate", %{"customer" => customer_params}, socket) do
    changeset = Persons.change_customer(socket.assigns.customer, customer_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"customer" => customer_params}, socket) do
    save_customer(socket, socket.assigns.action, customer_params)
  end

  defp save_customer(socket, :edit, customer_params) do
    case Persons.update_customer(socket.assigns.customer, customer_params) do
      {:ok, customer} ->
        notify_parent({:saved, customer})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Customer updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_customer(socket, :new, customer_params) do
    case Persons.create_customer(customer_params) do
      {:ok, customer} ->
        notify_parent({:saved, customer})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Customer created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
