defmodule Clerk.MultipleInstancesTest do
  use ExUnit.Case, async: false

  alias Clerk.Config

  defmodule InstanceAFetchingStrategy do
    use JokenJwks.DefaultStrategyTemplate

    def init_opts(opts), do: Keyword.put(opts, :should_start, false)
  end

  defmodule InstanceBFetchingStrategy do
    use JokenJwks.DefaultStrategyTemplate

    def init_opts(opts), do: Keyword.put(opts, :should_start, false)
  end

  setup do
    on_exit(fn ->
      for name <- [Clerk.InstanceA, Clerk.InstanceB, Clerk.RequiresStrategy, Clerk] do
        if Process.whereis(name) do
          try do
            Supervisor.stop(name, :normal)
          catch
            :exit, _ -> :ok
          end
        end
      end
    end)

    :ok
  end

  test "starts multiple Clerk supervisors with unique names" do
    assert {:ok, _} =
             Clerk.start_link(
               Config.new(
                 domain: "a.clerk.accounts.dev",
                 name: Clerk.InstanceA,
                 fetching_strategy: InstanceAFetchingStrategy,
                 should_start: false
               )
             )

    assert {:ok, _} =
             Clerk.start_link(
               Config.new(
                 domain: "b.clerk.accounts.dev",
                 name: Clerk.InstanceB,
                 fetching_strategy: InstanceBFetchingStrategy,
                 should_start: false
               )
             )

    assert Process.whereis(Clerk.InstanceA)
    assert Process.whereis(Clerk.InstanceB)
    assert Process.whereis(Clerk.InstanceA.HTTP)
    assert Process.whereis(Clerk.InstanceB.HTTP)
  end

  test "requires a custom fetching strategy when using a custom name" do
    assert {:error, {:missing_fetching_strategy, Clerk.RequiresStrategy}} =
             Clerk.start_link(
               Config.new(domain: "a.clerk.accounts.dev", name: Clerk.RequiresStrategy)
             )
  end

  test "config carries settings for API calls" do
    config =
      Config.new(
        domain: "a.clerk.accounts.dev",
        name: Clerk.InstanceA,
        secret_key: "sk_test_a",
        fetching_strategy: InstanceAFetchingStrategy,
        should_start: false
      )

    {:ok, _} = Clerk.start_link(config)

    assert config.domain == "a.clerk.accounts.dev"
    assert config.http_name == Clerk.InstanceA.HTTP
    assert config.secret_key == "sk_test_a"
    assert config.fetching_strategy == InstanceAFetchingStrategy
  end

  test "child_spec uses the configured name as id" do
    config =
      Config.new(
        domain: "a.clerk.accounts.dev",
        name: Clerk.InstanceA,
        fetching_strategy: InstanceAFetchingStrategy
      )

    spec = Clerk.child_spec(config)

    assert spec.id == Clerk.InstanceA
    assert spec.type == :supervisor
  end

  test "token_config_for uses config domain" do
    config =
      Config.new(
        domain: "a.clerk.accounts.dev",
        name: Clerk.InstanceA,
        secret_key: "sk_test_a",
        fetching_strategy: InstanceAFetchingStrategy
      )

    token_config = Clerk.Session.token_config_for(config)
    %Joken.Claim{validate: validate} = token_config["iss"]

    assert validate.("https://a.clerk.accounts.dev", %{}, %{})
    refute validate.("https://b.clerk.accounts.dev", %{}, %{})
  end

  test "default instance uses ClerkHTTP" do
    config =
      Config.new(
        domain: "default.clerk.accounts.dev",
        should_start: false
      )

    {:ok, _} = Clerk.start_link(config)

    assert config.http_name == ClerkHTTP
    assert Process.whereis(ClerkHTTP)
  end
end
