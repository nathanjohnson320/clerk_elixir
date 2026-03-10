defmodule Clerk.SessionTest do
  use ExUnit.Case, async: false

  alias Clerk.Session

  setup do
    original_domain = Application.get_env(:clerk, :domain)
    original_parties = Application.get_env(:clerk, :authorized_parties)

    Application.put_env(:clerk, :domain, "example.clerk.accounts.dev")

    on_exit(fn ->
      if original_domain do
        Application.put_env(:clerk, :domain, original_domain)
      else
        Application.delete_env(:clerk, :domain)
      end

      if original_parties do
        Application.put_env(:clerk, :authorized_parties, original_parties)
      else
        Application.delete_env(:clerk, :authorized_parties)
      end
    end)

    :ok
  end

  describe "token_config/0 without authorized_parties" do
    test "does not include an azp claim validator when authorized_parties is not configured" do
      Application.delete_env(:clerk, :authorized_parties)

      config = Session.token_config()

      refute Map.has_key?(config, "azp")
    end

    test "does not include an azp claim validator when authorized_parties is an empty list" do
      Application.put_env(:clerk, :authorized_parties, [])

      config = Session.token_config()

      refute Map.has_key?(config, "azp")
    end

    test "does not include an azp claim validator when authorized_parties is nil" do
      Application.put_env(:clerk, :authorized_parties, nil)

      config = Session.token_config()

      refute Map.has_key?(config, "azp")
    end
  end

  describe "token_config/0 with authorized_parties" do
    test "includes an azp claim validator when authorized_parties is configured" do
      Application.put_env(:clerk, :authorized_parties, ["https://app.example.com"])

      config = Session.token_config()

      assert Map.has_key?(config, "azp")
      assert %Joken.Claim{validate: validate} = config["azp"]
      assert is_function(validate, 3)
    end

    test "azp validator accepts values in the configured list" do
      Application.put_env(:clerk, :authorized_parties, [
        "https://app.example.com",
        "https://other.example.com"
      ])

      config = Session.token_config()
      %Joken.Claim{validate: validate} = config["azp"]

      assert validate.("https://app.example.com", %{}, %{})
      assert validate.("https://other.example.com", %{}, %{})
    end

    test "azp validator rejects values not in the configured list" do
      Application.put_env(:clerk, :authorized_parties, ["https://app.example.com"])

      config = Session.token_config()
      %Joken.Claim{validate: validate} = config["azp"]

      refute validate.("https://evil.example.com", %{}, %{})
      refute validate.("https://app.example.com.evil.com", %{}, %{})
    end
  end

  describe "token_config/0 iss claim" do
    test "includes an iss claim validator" do
      config = Session.token_config()

      assert Map.has_key?(config, "iss")
      assert %Joken.Claim{validate: validate} = config["iss"]
      assert is_function(validate, 3)
    end

    test "iss validator accepts the correct issuer" do
      config = Session.token_config()
      %Joken.Claim{validate: validate} = config["iss"]

      assert validate.("https://example.clerk.accounts.dev", %{}, %{})
    end

    test "iss validator rejects an incorrect issuer" do
      config = Session.token_config()
      %Joken.Claim{validate: validate} = config["iss"]

      refute validate.("https://evil.clerk.accounts.dev", %{}, %{})
      refute validate.("https://example.clerk.accounts.dev.evil.com", %{}, %{})
    end
  end
end
