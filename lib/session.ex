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
  ```

  When running multiple Clerk tenants, pass the same `%Clerk.Config{}` used to
  start the supervisor:

  ```elixir
    Clerk.Session.verify_and_validate(jwt, config: config)
  ```
  """
  import Joken.Config, only: [default_claims: 1, add_claim: 4]

  alias Clerk.Config
  alias Clerk.HTTP

  def token_config do
    token_config_for(Config.default())
  end

  def token_config_for(%Config{} = config) do
    domain = config.domain
    authorized_parties = config.authorized_parties

    token_config =
      [skip: [:iss]]
      |> default_claims()
      |> add_claim(
        "iss",
        fn -> "https://#{domain}" end,
        &(&1 == "https://#{domain}")
      )

    if is_list(authorized_parties) and authorized_parties != [] do
      add_claim(token_config, "azp", nil, &(&1 in authorized_parties))
    else
      token_config
    end
  end

  def verify_and_validate(token, opts \\ []) do
    config = config(opts)

    Joken.verify_and_validate(
      token_config_for(config),
      token,
      nil,
      %{},
      [{JokenJwks, strategy: config.fetching_strategy}]
    )
  end

  def verify_and_validate!(token, opts \\ []) do
    case verify_and_validate(token, opts) do
      {:ok, claims} -> claims
      {:error, reason} -> raise Joken.Error, reason
    end
  end

  @doc """
  The Session object is an abstraction over an HTTP session. It models the period of information exchange between a user and the server. Sessions are created when a user successfully goes through the sign in or sign up flows.

  https://clerk.com/docs/reference/clerkjs/session

  ## QUERY PARAMETERS
  ### client_id
  string
  List sessions for the given client

  ### user_id
  string
  List sessions for the given user

  ### status
  string
  Filter sessions by the provided status

  Enum: "abandoned" "active" "ended" "expired" "removed" "replaced" "revoked"

  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.
  """
  def list(params, opts \\ []) do
    HTTP.get("/v1/sessions", params, opts)
  end

  @doc """
  Retrieve the details of a session
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/sessions/#{id}", opts)
  end

  @doc """
  Sets the status of a session as "revoked", which is an unauthenticated state. In multi-session mode, a revoked session will still be returned along with its client object, however the user will need to sign in again.
  """
  def revoke(id, opts \\ []) do
    HTTP.post("/v1/sessions/#{id}/revoke", opts)
  end

  @doc """
  Creates a JSON Web Token(JWT) based on a session and a JWT Template name defined for your instance
  """
  def create_session_from_jwt_template(session_id, jwt_template, opts \\ []) do
    HTTP.post("/v1/sessions/#{session_id}/tokens/#{jwt_template}", %{}, opts)
  end

  defp config(opts) do
    case Keyword.get(opts, :config) do
      %Config{} = config -> config
      nil -> Config.default()
    end
  end
end
