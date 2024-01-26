defmodule Clerk do
  @moduledoc """
  clerk is a library for authenticating with ClerkJS.

  ## Installation

  The package can be installed by adding `clerk` to your list of dependencies in `mix.exs`:

  ```elixir

  def deps do
    [
      {:clerk, "~> 0.1.0"}
    ]
  end
  ```

  ## Usage

  ### Configuration

  ```elixir
    config :clerk,
      domain: "example.clerk.accounts.dev"
  ```

  ### In you application's supervisor:
  ```elixir
    children = [
      ...
      {Clerk, Application.get_all_env(:clerk)},
      ...
    ]
  ```
  """
  use Supervisor

  alias Clerk.Session.FetchingStrategy

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    domain = Keyword.fetch!(opts, :domain)

    children = [
      {FetchingStrategy, jwks_url: "https://#{domain}/.well-known/jwks.json"}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
