defmodule Aliancer.Persons.Customer do
  use Gettext, backend: AliancerWeb.Gettext
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :person_type, Ecto.Enum, values: [:natural, :legal], default: :natural
    field :first_name, :string
    field :second_name, :string
    field :id_number, :string
    field :notes, :string
    field :contact_phone, :string
    field :contact_email, :string
    field :addr_street, :string
    field :addr_number, :string
    field :addr_complement, :string
    field :addr_neighborhood, :string
    field :addr_city, :string
    field :addr_state, :string
    field :addr_postcode, :string
    field :addr_reference, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [
      :person_type,
      :first_name,
      :second_name,
      :id_number,
      :notes,
      :contact_phone,
      :contact_email,
      :addr_street,
      :addr_number,
      :addr_complement,
      :addr_neighborhood,
      :addr_city,
      :addr_state,
      :addr_postcode,
      :addr_reference
    ])
    |> validate_required([:person_type])
    |> validate_required_name
    |> validate_length(:first_name, min: 3)
    |> validate_length(:second_name, min: 3)
    |> validate_length(:addr_state, is: 2)
  end

  defp validate_required_name(%{changes: %{first_name: nil}} = changeset) do
    validate_required(changeset, [:second_name])
  end

  defp validate_required_name(%{changes: %{first_name: ""}} = changeset) do
    validate_required(changeset, [:second_name])
  end

  defp validate_required_name(changeset) do
    validate_required(changeset, [:first_name])
  end

  def person_type_select_options do
    for p <- Ecto.Enum.values(Aliancer.Persons.Customer, :person_type), into: %{} do
      {person_type_label(p), p}
    end
  end

  def person_type_label(person_type) do
    case person_type_to_atom(person_type) do
      :natural ->
        gettext("Natural person")

      :legal ->
        gettext("Legal person")
    end
  end

  def first_name_label(person_type) do
    case person_type_to_atom(person_type) do
      :natural ->
        gettext("First name")

      :legal ->
        gettext("Company name")
    end
  end

  def second_name_label(person_type) do
    case person_type_to_atom(person_type) do
      :natural ->
        gettext("Second name")

      :legal ->
        gettext("Trading name")
    end
  end

  def id_number_label(person_type) do
    case person_type_to_atom(person_type) do
      :natural ->
        gettext("Natural person tax ID")

      :legal ->
        gettext("Legal person tax ID")
    end
  end

  defp person_type_to_atom("natural"), do: :natural
  defp person_type_to_atom("legal"), do: :legal
  defp person_type_to_atom(:natural), do: :natural
  defp person_type_to_atom(:legal), do: :legal
end
