defmodule Clerk.ActorToken do
  alias Clerk.HTTP

  @doc """
  Allow your users to sign in on behalf of other users.

  https://clerk.com/docs/authentication/user-impersonation#actor-tokens

  ## REQUEST BODY SCHEMA: application/json
  ### user_id
  required
  string
  The ID of the user that can use the newly created sign in token.

  ### actor
  required
  object
  The actor payload. It needs to include a sub property which should contain the ID of the actor. This whole payload will be also included in the JWT session token.

  ### expires_in_seconds
  integer
  Default: 3600
  Optional parameter to specify the life duration of the actor token in seconds. By default, the duration is 1 hour.

  ### session_max_duration_in_seconds
  integer
  Default: 1800
  The maximum duration that the session which will be created by the generated actor token should last. By default, the duration of a session created via an actor token, lasts 30 minutes.
  """
  def create(user_id, actor_id, params, opts \\ []) do
    HTTP.post(
      "/v1/actor_tokens",
      Map.merge(params, %{"user_id" => user_id, "actor_id" => actor_id}),
      %{},
      opts
    )
  end

  def revoke(actor_token_id, opts \\ []) do
    HTTP.post("/v1/actor_tokens/#{actor_token_id}", %{}, %{}, opts)
  end
end
