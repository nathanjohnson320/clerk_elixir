defmodule Clerk.ConfigTest do
  use ExUnit.Case, async: true

  alias Clerk.Config
  alias Clerk.Session.FetchingStrategy

  defmodule CustomFetchingStrategy do
    use JokenJwks.DefaultStrategyTemplate
  end

  test "new/1 builds a config struct with derived http_name" do
    config =
      Config.new(
        domain: "a.clerk.accounts.dev",
        name: Clerk.InstanceA,
        secret_key: "sk_test_a",
        fetching_strategy: CustomFetchingStrategy,
        authorized_parties: ["https://app.example.com"]
      )

    assert config.domain == "a.clerk.accounts.dev"
    assert config.name == Clerk.InstanceA
    assert config.secret_key == "sk_test_a"
    assert config.fetching_strategy == CustomFetchingStrategy
    assert config.http_name == Clerk.InstanceA.HTTP
    assert config.authorized_parties == ["https://app.example.com"]
  end

  test "new/1 defaults to Clerk and ClerkHTTP" do
    config = Config.new(domain: "example.clerk.accounts.dev")

    assert config.name == Clerk
    assert config.http_name == ClerkHTTP
    assert config.fetching_strategy == FetchingStrategy
  end

  test "validate/1 requires a custom fetching strategy for custom names" do
    config = Config.new(domain: "a.clerk.accounts.dev", name: Clerk.InstanceA)

    assert {:error, {:missing_fetching_strategy, Clerk.InstanceA}} = Config.validate(config)
  end

  test "validate/1 accepts the default Clerk name without a custom strategy" do
    config = Config.new(domain: "example.clerk.accounts.dev")

    assert :ok = Config.validate(config)
  end

  test "from_application_env/0 reads application config" do
    original = Application.get_env(:clerk, :secret_key)
    Application.put_env(:clerk, :secret_key, "sk_from_app")

    on_exit(fn ->
      if original do
        Application.put_env(:clerk, :secret_key, original)
      else
        Application.delete_env(:clerk, :secret_key)
      end
    end)

    config = Config.from_application_env()

    assert config.name == Clerk
    assert config.secret_key == "sk_from_app"
  end
end
