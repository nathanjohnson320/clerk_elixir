defmodule Clerk.Session do
  @moduledoc """
  Session handles the JWT validation and decoding.

  ## Usage

  ```elixir
    Clerk.Session.verify_and_validate!(jwt)
    %{
      "azp" => "https://example.accounts.dev",
      "exp" => 1706308195,
      "iat" => 1706308135,
      "iss" => "https://example.clerk.accounts.dev",
      "nbf" => 1706308125,
      "sid" => "sess_2bVftP1rQemOu4CPj9999999999",
      "sub" => "user_2bVftRtFezPdchfaz9999999999"
    }
  """
  use Joken.Config

  alias Clerk.Session.FetchingStrategy

  add_hook(JokenJwks, strategy: FetchingStrategy)

  @impl true
  def token_config do
    domain = Application.get_env(:clerk, :domain)

    [skip: [:iss]]
    |> default_claims()
    |> add_claim(
      "iss",
      fn -> "https://#{domain}" end,
      &(&1 == "https://#{domain}")
    )
  end
end
