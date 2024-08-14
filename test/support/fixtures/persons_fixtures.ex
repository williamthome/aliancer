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
end
