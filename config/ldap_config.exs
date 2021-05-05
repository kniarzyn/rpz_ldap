use Mix.Config

# Configure Exldap
server =
  System.get_env("LDAP_SERVER") ||
    raise """
    environment variable LDAP_SERVER is missing.
    """

base =
  System.get_env("LDAP_BASE") ||
    raise """
    environment variable LDAP_BASE is missing.
    For example: OU=ABC,dc=home,dc=pl
    """

port =
  System.get_env("LDAP_PORT") ||
    raise """
    environment variable LDAP_PORT is missing.
    for example: 389 for non-ssl(ldap), 636 for ssl(ldaps)
    """

user_dn =
  System.get_env("LDAP_USERDN") ||
    raise """
    environment variable LDAP_USERDN is missing.
    for example: domain//username
    """

password =
  System.get_env("LDAP_PASSWORD") ||
    raise """
    environment variable LDAP_PASSWORD is missing.
    for example: lelum
    """

config :exldap, :settings,
  server: server,
  base: base,
  port: 389,
  ssl: false,
  user_dn: user_dn,
  password: password,
  search_timeout: 5_000
