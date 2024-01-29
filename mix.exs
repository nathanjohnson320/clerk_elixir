defmodule Clerk.MixProject do
  use Mix.Project

  def project do
    [
      app: :clerk,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:joken, "~> 2.6"},
      {:joken_jwks, "~> 1.6"},
      {:plug, ">= 0.0.0"},
      {:finch, "~> 0.17.0"},
      {:multipart, "~> 0.4.0"}
    ]
  end
end
