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

  describe "employees" do
    alias Aliancer.Persons.Employee

    import Aliancer.PersonsFixtures

    @invalid_attrs %{
      name: nil,
      salary: nil,
      hire_date: nil,
      dismiss_date: nil,
      job_name: nil,
      birth_date: nil
    }

    test "count_employees/0 returns employees count" do
      assert Persons.count_employees() == 0
      _employee = employee_fixture()
      assert Persons.count_employees() == 1
    end

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Persons.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Persons.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      valid_attrs = %{
        name: "some name",
        salary: "120.5",
        hire_date: ~D[2024-08-15],
        dismiss_date: ~D[2024-08-15],
        job_name: "some job_name",
        birth_date: ~D[2024-08-15]
      }

      assert {:ok, %Employee{} = employee} = Persons.create_employee(valid_attrs)
      assert employee.name == "some name"
      assert employee.salary == Decimal.new("120.5")
      assert employee.hire_date == ~D[2024-08-15]
      assert employee.dismiss_date == ~D[2024-08-15]
      assert employee.job_name == "some job_name"
      assert employee.birth_date == ~D[2024-08-15]
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Persons.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()

      update_attrs = %{
        name: "some updated name",
        salary: "456.7",
        hire_date: ~D[2024-08-16],
        dismiss_date: ~D[2024-08-16],
        job_name: "some updated job_name",
        birth_date: ~D[2024-08-16]
      }

      assert {:ok, %Employee{} = employee} = Persons.update_employee(employee, update_attrs)
      assert employee.name == "some updated name"
      assert employee.salary == Decimal.new("456.7")
      assert employee.hire_date == ~D[2024-08-16]
      assert employee.dismiss_date == ~D[2024-08-16]
      assert employee.job_name == "some updated job_name"
      assert employee.birth_date == ~D[2024-08-16]
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Persons.update_employee(employee, @invalid_attrs)
      assert employee == Persons.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Persons.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Persons.change_employee(employee)
    end
  end
end
