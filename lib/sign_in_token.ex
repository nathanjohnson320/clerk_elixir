defmodule Clerk.SignInToken do
  alias Clerk.HTTP

  @doc """
  Creates a new sign-in token and associates it with the given user. By default, sign-in tokens expire in 30 days. You can optionally supply a different duration in seconds using the expires_in_seconds property.

  ## REQUEST BODY SCHEMA: application/json

  ### user_id
  string
  The ID of the user that can use the newly created sign in token

  ### expires_in_seconds
  integer
  Default: 2592000
  Optional parameter to specify the life duration of the sign in token in seconds. By default, the duration is 30 days.
  """
  def create(user_id, params \\ %{}, opts \\ []) do
    HTTP.post(
      "/v1/sign_in_tokens",
      Map.put(params, :user_id, user_id),
      opts
    )
  end

  @doc """
  Revokes a pending sign-in token
  """
  def revoke(id, opts \\ []) do
    HTTP.post("/v1/sign_in_tokens/#{id}/revoke", opts)
  end
end
