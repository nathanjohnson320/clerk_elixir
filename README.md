# Clerk

HTTP client for the ClerkJS sdk. https://clerk.com/docs/reference/backend-api

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `clerk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clerk, "~> 0.2.0"}
  ]
end
```

Once the dependency is installed you can add your clerk domain to the config, the clerk module to the application tree, and then
you can make API calls.

### in the config

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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/clerk>.
