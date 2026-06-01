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

  ### In your application's supervisor:
  ```elixir
    children = [
      ...
      {Clerk, Application.get_all_env(:clerk)},
      ...
    ]
  ```
  """
  use Supervisor

  alias Clerk.Instance
  alias Clerk.Session.FetchingStrategy

  @doc false
  def child_spec(arg) do
    name = Keyword.get(arg, :name, __MODULE__)

    %{
      id: name,
      start: {__MODULE__, :start_link, [arg]},
      type: :supervisor
    }
  end

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    with :ok <- validate_opts(name, opts) do
      Supervisor.start_link(__MODULE__, opts, name: name)
    end
  end

  def init(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    domain = Keyword.fetch!(opts, :domain)
    secret_key = Keyword.get(opts, :secret_key)
    authorized_parties = Keyword.get(opts, :authorized_parties)
    fetching_strategy = Keyword.get(opts, :fetching_strategy, FetchingStrategy)
    http_name = http_name(name)

    Instance.register(name, %{
      domain: domain,
      http_name: http_name,
      secret_key: secret_key,
      fetching_strategy: fetching_strategy,
      authorized_parties: authorized_parties
    })

    strategy_opts =
      [
        name: fetching_strategy,
        first_fetch_sync: true,
        retries: 3,
        jwks_url: "https://#{domain}/.well-known/jwks.json"
      ]
      |> Keyword.merge(Keyword.take(opts, [:should_start]))

    children = [
      {Instance.Cleanup, instance: name},
      {fetching_strategy, strategy_opts},
      {Finch, name: http_name}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp validate_opts(name, opts) do
    if name != __MODULE__ and not Keyword.has_key?(opts, :fetching_strategy) do
      {:error, {:missing_fetching_strategy, name}}
    else
      :ok
    end
  end

  defp http_name(Clerk), do: ClerkHTTP
  defp http_name(name), do: Module.concat(name, HTTP)
end
