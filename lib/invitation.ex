defmodule Clerk.Invitation do
  @moduledoc """
  Invitations allow you to invite someone to sign up to your application, via email.

  https://clerk.com/docs/authentication/invitations
  """

  alias Clerk.HTTP

  @doc """
  Creates a new invitation for the given email address and sends the invitation email. Keep in mind that you cannot create an invitation if there is already one for the given email address. Also, trying to create an invitation for an email address that already exists in your application will result to an error.

  ## REQUEST BODY SCHEMA: application/json
  Required parameters

  ### email_address
  required
  string
  The email address the invitation will be sent to

  ### public_metadata
  object
  Metadata that will be attached to the newly created invitation. The value of this property should be a well-formed JSON object. Once the user accepts the invitation and signs up, these metadata will end up in the user's public metadata.

  ### redirect_url
  string
  Optional URL which specifies where to redirect the user once they click the invitation link. This is only required if you have implemented a custom flow and you're not using Clerk Hosted Pages or Clerk Components.

  ### notify
  boolean or null
  Default: true
  Optional flag which denotes whether an email invitation should be sent to the given email address. Defaults to true.

  ### ignore_existing
  boolean or null
  Default: false
  Whether an invitation should be created if there is already an existing invitation for this email address, or it's claimed by another user.
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/invitations", params, %{}, opts)
  end

  @doc """
  Returns all non-revoked invitations for your application, sorted by creation date

  ## QUERY PARAMETERS
  ### status
  string
  Filter invitations based on their status

  Enum: "pending" "accepted" "revoked"
  """
  def list(params, opts \\ []) do
    HTTP.get("/v1/invitations", params, opts)
  end

  @doc """
  Revokes the given invitation. Revoking an invitation will prevent the user from using the invitation link that was sent to them. However, it doesn't prevent the user from signing up if they follow the sign up flow. Only active (i.e. non-revoked) invitations can be revoked.
  """
  def revoke(id, opts \\ []) do
    HTTP.post("/v1/invitations/#{id}/revoke", %{}, %{}, opts)
  end
end
