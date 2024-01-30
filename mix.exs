defmodule Clerk.MixProject do
  use Mix.Project

  def project do
    [
      app: :clerk,
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Clerk SDK"
    ]
  end

  defp description() do
    "Client SDK for ClerkJS https://clerk.com/docs/reference/backend-api"
  end

  defp package() do
    [
      name: "clerk",
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nathanjohnson320/clerk_elixir"}
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
