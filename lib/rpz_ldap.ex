defmodule RpzLdap do
  alias RpzLdap.Employee

  def connect(timeout \\ 3_000), do: Exldap.connect(timeout)

  @spec get_employee(String.t()) :: Employee.t()
  def get_employee(employee_number) do
    employee_number = String.pad_leading(employee_number, 8, "0")

    {:ok, ldap_conn} = connect()

    {:ok, [ldap_entry | _]} = Exldap.search_field(ldap_conn, "employeeNumber", employee_number)

    Employee.new(ldap_entry)
  end
end
