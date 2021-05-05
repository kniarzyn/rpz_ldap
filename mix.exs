defmodule RpzLdap.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpz_ldap,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:exldap],
      extra_applications: [:logger],
      mod: {RpzLdap.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exldap, "~> 0.6"}
    ]
  end
end
