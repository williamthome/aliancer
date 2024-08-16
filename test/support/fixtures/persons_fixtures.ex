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
        address: "some address",
        email: "some email",
        name: "some name",
        notes: "some notes",
        phone: "some phone"
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
