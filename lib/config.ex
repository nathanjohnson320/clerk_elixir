defmodule Clerk.Config do
  @moduledoc """
  Configuration for a Clerk tenant connection.

  Build a config with `new/1`, start the supervisor with `{Clerk, config}`, and
  pass the same struct to API calls and plugs via the `config:` option.

  ## Examples

      config =
        Clerk.Config.new(
          name: AppA.Clerk,
          domain: "app-a.clerk.accounts.dev",
          secret_key: System.fetch_env!("APP_A_CLERK_SECRET_KEY"),
          fetching_strategy: AppA.Clerk.FetchingStrategy
        )

      children = [{Clerk, config}]
      Clerk.User.list(%{}, config: config)
  """

  alias Clerk.Session.FetchingStrategy

  @enforce_keys [:domain]
  defstruct [
    :domain,
    :secret_key,
    :authorized_parties,
    :should_start,
    fetching_strategy: FetchingStrategy,
    http_name: nil,
    name: Clerk
  ]

  @type t :: %__MODULE__{
          domain: String.t(),
          secret_key: String.t() | nil,
          authorized_parties: [String.t()] | nil,
          fetching_strategy: module(),
          http_name: atom(),
          name: atom()
        }

  @doc """
  Builds a `%Clerk.Config{}` from keyword options.

  Required:

    * `:domain` - the Clerk Frontend API domain (e.g. `"app.clerk.accounts.dev"`)

  Optional:

    * `:name` - supervisor and process name. Defaults to `Clerk`.
    * `:secret_key` - Backend API secret key.
    * `:authorized_parties` - allowlist for JWT `azp` claim validation.
    * `:fetching_strategy` - JWKS fetching strategy module. Required when `:name`
      is not `Clerk`.
    * `:http_name` - Finch pool name. Derived from `:name` when omitted.
  """
  def new(opts) when is_list(opts) do
    name = Keyword.get(opts, :name, Clerk)
    fetching_strategy = Keyword.get(opts, :fetching_strategy, FetchingStrategy)
    http_name = Keyword.get(opts, :http_name, http_name(name))

    struct!(__MODULE__, [
      name: name,
      domain: Keyword.fetch!(opts, :domain),
      secret_key: Keyword.get(opts, :secret_key),
      authorized_parties: Keyword.get(opts, :authorized_parties),
      fetching_strategy: fetching_strategy,
      http_name: http_name,
      should_start: Keyword.get(opts, :should_start)
    ])
  end

  @doc """
  Builds a config from `Application.get_env/2` for the `:clerk` app.

  Used as the default when API calls omit `config:`.
  """
  def from_application_env do
    new(
      domain: Application.get_env(:clerk, :domain),
      secret_key: Application.get_env(:clerk, :secret_key),
      authorized_parties: Application.get_env(:clerk, :authorized_parties)
    )
  end

  @doc false
  def validate(%__MODULE__{name: Clerk}), do: :ok

  def validate(%__MODULE__{name: name, fetching_strategy: FetchingStrategy}) do
    {:error, {:missing_fetching_strategy, name}}
  end

  def validate(%__MODULE__{}), do: :ok

  defp http_name(Clerk), do: ClerkHTTP
  defp http_name(name), do: Module.concat(name, HTTP)
end
