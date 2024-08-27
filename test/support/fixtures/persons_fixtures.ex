defmodule Aliancer.PersonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Persons` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        person_type: :natural,
        first_name: "some first_name",
        second_name: "some second_name",
        id_number: "0",
        notes: "some notes",
        contact_phone: "some contact_phone",
        contact_email: "some contact_email",
        addr_street: "some addr_street",
        addr_number: "some addr_number",
        addr_complement: "some addr_complement",
        addr_neighborhood: "some addr_neighborhood",
        addr_city: "some addr_city",
        addr_state: "SC",
        addr_postcode: "some addr_postcode",
        addr_reference: "some addr_reference"
      })
      |> Aliancer.Persons.create_customer()

    customer
  end

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2024-08-15],
        dismiss_date: ~D[2024-08-15],
        hire_date: ~D[2024-08-15],
        job_name: "some job_name",
        name: "some name",
        salary: "120.5"
      })
      |> Aliancer.Persons.create_employee()

    employee
  end
end
