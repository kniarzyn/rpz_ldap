defmodule RpzLdap.Employee do
  use Bitwise, only_operators: true

  @type t :: %__MODULE__{
          id: String.t(),
          first_name: String.t(),
          last_name: String.t(),
          givenName: String.t(),
          phone_number: String.t(),
          department: String.t(),
          department_shortcut: String.t(),
          manager_object_name: String.t(),
          display_name: String.t(),
          mail: String.t(),
          sAMAccountName: String.t(),
          userAccountControl: integer(),
          org_unit: String.t(),
          object_name: String.t(),
          active: boolean(),
          roles: any,
          checked?: boolean(),
          on_remote?: boolean()
        }

  @user_account_control_accountdisable_flag 0x0002

  defstruct [
    :id,
    :first_name,
    :last_name,
    :givenName,
    :phone_number,
    :department,
    :department_shortcut,
    :manager_object_name,
    :display_name,
    :mail,
    :sAMAccountName,
    :userAccountControl,
    :org_unit,
    :object_name,
    :active,
    :roles,
    :checked?,
    :on_remote?
  ]

  @spec new(ldap_entry :: Exldap.Entry.t()) :: Employee.t()
  def new(ldap_entry) do
    ldap_entry
    |> make_unchecked_employee()
    |> check_if_active()
  end

  ##############################################################################
  ### Private functions
  defp make_unchecked_employee(ldap_entry) do
    employee_id = Exldap.get_attribute!(ldap_entry, "employeeNumber")

    org_unit =
      Exldap.get_attribute!(ldap_entry, "physicalDeliveryOfficeName")
      |> String.replace(".", "")

    %__MODULE__{
      id: employee_id,
      first_name: Exldap.get_attribute!(ldap_entry, "givenName"),
      last_name: Exldap.get_attribute!(ldap_entry, "sn"),
      display_name: Exldap.get_attribute!(ldap_entry, "displayName"),
      phone_number: Exldap.get_attribute!(ldap_entry, "telephoneNumber"),
      department: Exldap.get_attribute!(ldap_entry, "department"),
      department_shortcut: String.first(org_unit),
      org_unit: org_unit,
      manager_object_name: Exldap.get_attribute!(ldap_entry, "manager"),
      mail: Exldap.get_attribute!(ldap_entry, "mail"),
      sAMAccountName: Exldap.get_attribute!(ldap_entry, "sAMAccountName"),
      userAccountControl: Exldap.get_attribute!(ldap_entry, "userAccountControl"),
      object_name: ldap_entry.object_name
    }
  end

  defp check_if_active(%__MODULE__{} = employee) do
    active? =
      case technical_account?(employee) do
        true ->
          false

        false ->
          active_account?(employee)
      end

    Map.put(employee, :active, active?)
  end

  defp technical_account?(employee), do: String.starts_with?(employee.sAMAccountName, "adm")

  defp active_account?(employee) do
    # 66048 &&& @user_account_control_accountdisable_flag
    (String.to_integer(employee.userAccountControl) &&&
       @user_account_control_accountdisable_flag)
    |> Kernel.==(0)
  end
end
