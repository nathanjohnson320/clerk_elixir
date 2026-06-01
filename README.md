# Clerk

HTTP client for the ClerkJS sdk. <https://clerk.com/docs/reference/backend-api>

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `clerk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clerk, "~> 1.2.0"}
  ]
end
```

Once the dependency is installed you can add your clerk domain and secret key to the config, the clerk module to the application tree, and then you can make API calls.

### in the config

```elixir
  config :clerk,
    domain: "example.clerk.accounts.dev",
    secret_key: System.get_env("CLERK_API_KEY") || raise("CLERK_API_KEY environment variable is missing.")

```

## Exporting the secret key via bash

You can also export the secret key via bash. This is useful for local development.

```bash
export CLERK_API_KEY=sk_test_your-secret-key
```

### Using dotenv in development to serve the clerk test api key

If you want to use a .env file, can use dotenv to load the config from a `.env` file. This is useful for local development. In production, you should set the environment variables directly into the server.

```
# .env
CLERK_API_KEY=sk_somekeyabc123
```

### In your application's supervisor

```elixir
  children = [
    ...
    {Clerk, Application.get_all_env(:clerk)},
    ...
  ]
```

and then

```elixir
  iex> Clerk.User.list()
  {:ok,
    [
      %{
        "id" => "user_abcd12345",
        "locked" => false,
        "has_image" => true,
        "banned" => false,
        ...
      }
    ]
  }
```

You can also use the `Clerk.AuthenticationPlug` to automatically load the clerk session and user
in plug based elixir applications. i.e. (in phoenix):

```elixir
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Clerk.AuthenticationPlug
  end
```

will place a `current_user` object in `conn.assigns`

## Multiple instances (umbrella apps)

In an umbrella application, all child apps run on the same BEAM node. The default Clerk
supervisor registers under the fixed name `Clerk`, and its Finch pool uses `ClerkHTTP`.
Starting a second `{Clerk, ...}` child will crash with an `already started` error.

If each umbrella child app connects to a **different** Clerk instance, give each supervisor
a unique name and a dedicated JWKS fetching strategy module (required by
[JokenJwks](https://hexdocs.pm/joken_jwks/JokenJwks.DefaultStrategyTemplate.html)).

### 1. Define a fetching strategy per Clerk tenant

```elixir
defmodule AppA.Clerk.FetchingStrategy do
  use JokenJwks.DefaultStrategyTemplate
end
```

### 2. Build a config and start the supervisor

Do not rely on shared `config :clerk` for domain or secret key in multi-tenant setups —
umbrella apps share one config namespace. Build a `%Clerk.Config{}` and keep a reference
to pass on every API call and plug.

```elixir
# apps/app_a/lib/app_a/clerk_config.ex
defmodule AppA.ClerkConfig do
  def config do
    Clerk.Config.new(
      name: AppA.Clerk,
      domain: "app-a.clerk.accounts.dev",
      secret_key: System.fetch_env!("APP_A_CLERK_SECRET_KEY"),
      fetching_strategy: AppA.Clerk.FetchingStrategy,
      authorized_parties: ["https://app-a.example.com"]
    )
  end
end

# apps/app_a/lib/app_a/application.ex
config = AppA.ClerkConfig.config()

children = [
  {Clerk, config}
]
```

`authorized_parties` is optional. When set, session JWT verification for that config
validates the token's `azp` (authorized party) claim against the list. Omit it, or pass
an empty list, to skip `azp` validation. In a single-app setup, the same option can be
set via `config :clerk, authorized_parties: [...]`.

### 3. Pass `config:` on API calls and authentication

```elixir
config = AppA.ClerkConfig.config()

Clerk.User.list(%{}, config: config)
Clerk.Session.verify_and_validate(token, config: config)
plug Clerk.AuthenticationPlug, config: config
```

Single-app usage with `config :clerk` and `{Clerk, Application.get_all_env(:clerk)}` is
unchanged and does not require `config:`.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/clerk>.
