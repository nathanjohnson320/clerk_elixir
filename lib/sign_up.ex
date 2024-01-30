defmodule Clerk.SignUp do
  @moduledoc """
  https://clerk.com/docs/reference/backend-api/tag/Sign-ups
  """

  alias Clerk.HTTP

  @doc """
  Update the sign-up with the given ID

  ## REQUEST BODY SCHEMA: application/json
  ### custom_action
  boolean
  Specifies whether a custom action has run for this sign-up attempt. This is important when your instance has been configured to require a custom action to run before converting a sign-up into a user. After executing any external business logic you deem necessary, you can mark the sign-up as ready-to-convert by setting custom_action to true.

  ### external_id
  string or null
  The ID of the guest attempting to sign up as used in your external systems or your previous authentication solution. This will be copied to the resulting user when the sign-up is completed.
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/sign_ups/#{id}", params, %{}, opts)
  end
end
