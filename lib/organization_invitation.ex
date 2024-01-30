defmodule Clerk.OrganizationInvitation do
  @moduledoc """
  Invite users to an organization.

  https://clerk.com/docs/organizations/invite-users
  """

  alias Clerk.HTTP

  @doc """
  Creates a new organization invitation and sends an email to the provided email_address with a link to accept the invitation and join the organization. You can specify the role for the invited organization member.

  New organization invitations get a "pending" status until they are revoked by an organization administrator or accepted by the invitee.

  The request body supports passing an optional redirect_url parameter. When the invited user clicks the link to accept the invitation, they will be redirected to the URL provided. Use this parameter to implement a custom invitation acceptance flow.

  You must specify the ID of the user that will send the invitation with the inviter_user_id parameter. That user must be a member with administrator privileges in the organization. Only "admin" members can create organization invitations.

  You can optionally provide public and private metadata for the organization invitation. The public metadata are visible by both the Frontend and the Backend whereas the private ones only by the Backend. When the organization invitation is accepted, the metadata will be transferred to the newly created organization membership.

  ## REQUEST BODY SCHEMA: application/json

  ### email_address
  required
  string
  The email address of the new member that is going to be invited to the organization

  ### inviter_user_id
  required
  string
  The ID of the user that invites the new member to the organization. Must be an administrator in the organization.

  ### role
  required
  string
  The role of the new member in the organization

  ### public_metadata
  object
  Metadata saved on the organization invitation, read-only from the Frontend API and fully accessible (read/write) from the Backend API.

  ### private_metadata
  object
  Metadata saved on the organization invitation, fully accessible (read/write) from the Backend API but not visible from the Frontend API.

  ### redirect_url
  string
  Optional URL that the invitee will be redirected to once they accept the invitation by clicking the join link in the invitation email.
  """
  def create(organization_id, params \\ %{}, opts \\ []) do
    HTTP.post("/v1/organizations/#{organization_id}/invitations", params, opts)
  end

  @doc """
  This request returns the list of organization invitations. Results can be paginated using the optional limit and offset query parameters. You can filter them by providing the 'status' query parameter, that accepts multiple values. The organization invitations are ordered by descending creation date. Most recent invitations will be returned first. Any invitations created as a result of an Organization Domain are not included in the results.

  ## QUERY PARAMETERS
  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.

  ### status
  string
  Filter organization invitations based on their status

  Enum: "pending" "accepted" "revoked"
  """
  def list(organization_id, params \\ %{}, opts \\ []) do
    HTTP.get("/v1/organizations/#{organization_id}/invitations", params, opts)
  end

  @doc """
  Creates new organization invitations in bulk and sends out emails to the provided email addresses with a link to accept the invitation and join the organization. You can specify a different role for each invited organization member. New organization invitations get a "pending" status until they are revoked by an organization administrator or accepted by the invitee. The request body supports passing an optional redirect_url parameter for each invitation. When the invited user clicks the link to accept the invitation, they will be redirected to the provided URL. Use this parameter to implement a custom invitation acceptance flow. You must specify the ID of the user that will send the invitation with the inviter_user_id parameter. Each invitation can have a different inviter user. Inviter users must be members with administrator privileges in the organization. Only "admin" members can create organization invitations. You can optionally provide public and private metadata for each organization invitation. The public metadata are visible by both the Frontend and the Backend, whereas the private metadata are only visible by the Backend. When the organization invitation is accepted, the metadata will be transferred to the newly created organization membership.

  ## REQUEST BODY SCHEMA: application/json

  Array
  ### email_address
  required
  string
  The email address of the new member that is going to be invited to the organization

  ### inviter_user_id
  required
  string
  The ID of the user that invites the new member to the organization. Must be an administrator in the organization.

  ### role
  required
  string
  The role of the new member in the organization.

  ### public_metadata
  object
  Metadata saved on the organization invitation, read-only from the Frontend API and fully accessible (read/write) from the Backend API.

  ### private_metadata
  object
  Metadata saved on the organization invitation, fully accessible (read/write) from the Backend API but not visible from the Frontend API.

  ### redirect_url
  string
  Optional URL that the invitee will be redirected to once they accept the invitation by clicking the join link in the invitation email.
  """
  def create_bulk(organization_id, params \\ %{}, opts \\ []) do
    HTTP.post("/v1/organizations/#{organization_id}/invitations/bulk", params, opts)
  end

  @doc """
  Use this request to get an existing organization invitation by ID.
  """
  def get(organization_id, invitation_id, opts \\ []) do
    HTTP.get("/v1/organizations/#{organization_id}/invitations/#{invitation_id}", %{}, opts)
  end

  @doc """
  Use this request to revoke a previously issued organization invitation. Revoking an organization invitation makes it invalid; the invited user will no longer be able to join the organization with the revoked invitation. Only organization invitations with "pending" status can be revoked. The request needs the requesting_user_id parameter to specify the user which revokes the invitation. Only users with "admin" role can revoke invitations.

  ## REQUEST BODY SCHEMA: application/json

  required
  ### requesting_user_id
  required
  string
  The ID of the user that revokes the invitation. Must be an administrator in the organization.
  """
  def revoke(organization_id, invitation_id, params, opts \\ []) do
    HTTP.post(
      "/v1/organizations/#{organization_id}/invitations/#{invitation_id}/revoke",
      params,
      opts
    )
  end
end
