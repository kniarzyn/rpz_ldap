defmodule RpzLdap do
  def connect(timeout \\ 3_000), do: Exldap.connect(timeout)
end
