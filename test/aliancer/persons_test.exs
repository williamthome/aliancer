defmodule Aliancer.PersonsTest do
  use Aliancer.DataCase

  alias Aliancer.Persons

  describe "customers" do
    alias Aliancer.Persons.Customer

    import Aliancer.PersonsFixtures

    @invalid_attrs %{name: nil, address: nil, phone: nil, email: nil, notes: nil}

    test "count_customers/0 returns customers count" do
      assert Persons.count_customers() == 0
      _customer = customer_fixture()
      assert Persons.count_customers() == 1
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Persons.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Persons.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        phone: "some phone",
        email: "some email",
        notes: "some notes"
      }

      assert {:ok, %Customer{} = customer} = Persons.create_customer(valid_attrs)
      assert customer.name == "some name"
      assert customer.address == "some address"
      assert customer.phone == "some phone"
      assert customer.email == "some email"
      assert customer.notes == "some notes"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Persons.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        phone: "some updated phone",
        email: "some updated email",
        notes: "some updated notes"
      }

      assert {:ok, %Customer{} = customer} = Persons.update_customer(customer, update_attrs)
      assert customer.name == "some updated name"
      assert customer.address == "some updated address"
      assert customer.phone == "some updated phone"
      assert customer.email == "some updated email"
      assert customer.notes == "some updated notes"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Persons.update_customer(customer, @invalid_attrs)
      assert customer == Persons.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Persons.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Persons.change_customer(customer)
    end
  end
end
