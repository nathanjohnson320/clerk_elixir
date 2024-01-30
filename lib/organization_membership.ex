defmodule Clerk.OrganizationMembership do
  @moduledoc """
  Manage member roles in an organization.

  https://clerk.com/docs/organizations/manage-member-roles
  """

  alias Clerk.HTTP

  @doc """
  Adds a user as a member to the given organization. Only users in the same instance as the organization can be added as members.

  ## REQUEST BODY SCHEMA: application/json

  ### user_id
  required
  string
  The ID of the user that will be added as a member in the organization. The user needs to exist in the same instance as the organization and must not be a member of the given organization already.

  ### role
  required
  string
  The role that the new member will have in the organization.
  """
  def create(organization_id, params \\ %{}, opts \\ []) do
    HTTP.post("/v1/organizations/#{organization_id}/memberships", params, opts)
  end

  @doc """
  Retrieves all user memberships for the given organization

  ## QUERY PARAMETERS
  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.

  ### order_by
  string
  Sorts organizations memberships by phone_number, email_address, created_at, first_name, last_name or username. By prepending one of those values with + or -, we can choose to sort in ascending (ASC) or descending (DESC) order."
  """
  def list(organization_id, params \\ %{}, opts \\ []) do
    HTTP.get("/v1/organizations/#{organization_id}/memberships", params, opts)
  end

  @doc """
  Updates the properties of an existing organization membership

  ## REQUEST BODY SCHEMA: application/json
  ### role
  required
  string
  The new role of the given membership.
  """
  def update(organization_id, user_id, params \\ %{}, opts \\ []) do
    HTTP.patch("/v1/organizations/#{organization_id}/memberships/#{user_id}", params, opts)
  end

  @doc """
  Removes the given membership from the organization
  """
  def delete(organization_id, user_id, params \\ %{}, opts \\ []) do
    HTTP.delete("/v1/organizations/#{organization_id}/memberships/#{user_id}", params, opts)
  end

  @doc """
  Update an organization membership's metadata attributes by merging existing values with the provided parameters. Metadata values will be updated via a deep merge. Deep means that any nested JSON objects will be merged as well. You can remove metadata keys at any level by setting their value to null.

  ## REQUEST BODY SCHEMA: application/json

  ### public_metadata
  object
  Metadata saved on the organization membership, that is visible to both your frontend and backend. The new object will be merged with the existing value.

  ### private_metadata
  object
  Metadata saved on the organization membership that is only visible to your backend. The new object will be merged with the existing value.
  """
  def update_metadata(organization_id, user_id, params \\ %{}, opts \\ []) do
    HTTP.patch(
      "/v1/organizations/#{organization_id}/memberships/#{user_id}/metadata",
      params,
      opts
    )
  end
end
