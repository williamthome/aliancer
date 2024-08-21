defmodule AliancerWeb.EmployeeLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Persons

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= gettext("Use this form to manage employee records in your database.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="employee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <.input field={@form[:job_name]} type="text" label={gettext("Job name")} />
        <.input field={@form[:salary]} type="number" label={gettext("Salary")} step="any" />
        <.input field={@form[:birth_date]} type="date" label={gettext("Birth date")} />
        <.input field={@form[:hire_date]} type="date" label={gettext("Hire date")} />
        <.input field={@form[:dismiss_date]} type="date" label={gettext("Dismiss date")} />
        <:actions>
          <.button phx-disable-with={gettext("Saving...")}>
            <%= gettext("Save Employee") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Persons.change_employee(employee))
     end)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset = Persons.change_employee(socket.assigns.employee, employee_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    save_employee(socket, socket.assigns.action, employee_params)
  end

  defp save_employee(socket, :edit, employee_params) do
    case Persons.update_employee(socket.assigns.employee, employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Employee updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Persons.create_employee(employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Employee created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
