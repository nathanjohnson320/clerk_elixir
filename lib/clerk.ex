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

  alias Clerk.Config

  @doc """
  Returns the default `%Clerk.Config{}` from `config :clerk`.

  Use this when you want to pass config explicitly without building a custom
  `%Clerk.Config{}` for multi-tenant setups:

      children = [{Clerk, Clerk.config()}]
      Clerk.User.list(%{}, config: Clerk.config())
  """
  def config, do: Config.default()

  @doc false
  def child_spec(arg) do
    config = config!(arg)

    %{
      id: config.name,
      start: {__MODULE__, :start_link, [config]},
      type: :supervisor
    }
  end

  def start_link(arg) do
    config = config!(arg)

    with :ok <- Config.validate(config) do
      Supervisor.start_link(__MODULE__, config, name: config.name)
    end
  end

  def init(%Config{} = config) do
    strategy_opts =
      [
        name: config.fetching_strategy,
        first_fetch_sync: true,
        retries: 3,
        jwks_url: "https://#{config.domain}/.well-known/jwks.json"
      ]
      |> maybe_put(:should_start, config.should_start)

    children = [
      {config.fetching_strategy, strategy_opts},
      {Finch, name: config.http_name}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp config!(%Config{} = config), do: config
  defp config!(opts) when is_list(opts), do: Config.new(opts)

  defp maybe_put(opts, _key, nil), do: opts
  defp maybe_put(opts, key, value), do: Keyword.put(opts, key, value)
end
