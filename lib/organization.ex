defmodule Clerk.Organization do
  @moduledoc """
  Organizations are used to group members under a common entity and provide shared access to resources.

  https://clerk.com/docs/organizations/overview
  """

  alias Clerk.HTTP

  @doc """
  This request returns the list of organizations for an instance. Results can be paginated using the optional limit and offset query parameters. The organizations are ordered by descending creation date. Most recent organizations will be returned first.

  ## QUERY PARAMETERS
  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.

  ### include_members_count
  boolean
  Flag to denote whether the member counts of each organization should be included in the response or not.

  ### query
  string
  Returns organizations with ID, name, or slug that match the given query. Uses exact match for organization ID and partial match for name and slug.

  ### order_by
  string
  Default: "-created_at"
  Allows to return organizations in a particular order. At the moment, you can order the returned organizations either by their name, created_at or members_count. In order to specify the direction, you can use the +/- symbols prepended in the property to order by. For example, if you want organizations to be returned in descending order according to their created_at property, you can use -created_at. If you don't use + or -, then + is implied. Defaults to -created_at.
  """
  def list(params \\ %{}, opts \\ []) do
    HTTP.get("/v1/organizations", params, opts)
  end

  @doc """
  Creates a new organization with the given name for an instance. In order to successfully create an organization you need to provide the ID of the User who will become the organization administrator. You can specify an optional slug for the new organization. If provided, the organization slug can contain only lowercase alphanumeric characters (letters and digits) and the dash "-". Organization slugs must be unique for the instance. You can provide additional metadata for the organization and set any custom attribute you want. Organizations support private and public metadata. Private metadata can only be accessed from the Backend API. Public metadata can be accessed from the Backend API, and are read-only from the Frontend API.

  ## REQUEST BODY SCHEMA: application/json
  ### name
  required
  string
  The name of the new organization

  ### created_by
  required
  string
  The ID of the User who will become the administrator for the new organization

  ### private_metadata
  object
  Metadata saved on the organization, accessible only from the Backend API

  ### public_metadata
  object
  Metadata saved on the organization, read-only from the Frontend API and fully accessible (read/write) from the Backend API

  ### slug
  string
  A slug for the new organization. Can contain only lowercase alphanumeric characters and the dash "-". Must be unique for the instance.

  ### max_allowed_memberships
  integer
  The maximum number of memberships allowed for this organization
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/organizations", params, opts)
  end

  @doc """
  Fetches the organization whose ID or slug matches the provided id_or_slug URL query parameter.
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/organizations/#{id}", %{}, opts)
  end

  @doc """
  Updates an existing organization

  ## REQUEST BODY SCHEMA: application/json

  ### public_metadata
  object
  Metadata saved on the organization, that is visible to both your frontend and backend.

  ### private_metadata
  object
  Metadata saved on the organization that is only visible to your backend.

  ### name
  string or null
  The new name of the organization

  ### slug
  string or null
  The new slug of the organization, which needs to be unique in the instance

  ### max_allowed_memberships
  integer or null
  The maximum number of memberships allowed for this organization

  ### admin_delete_enabled
  boolean or null
  If true, an admin can delete this organization with the Frontend API.
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/organizations/#{id}", params, opts)
  end

  @doc """
  Deletes the given organization. Please note that deleting an organization will also delete all memberships and invitations. This is not reversible.
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/organizations/#{id}", %{}, opts)
  end

  @doc """
  Update organization metadata attributes by merging existing values with the provided parameters. Metadata values will be updated via a deep merge. Deep meaning that any nested JSON objects will be merged as well. You can remove metadata keys at any level by setting their value to null.

  ## REQUEST BODY SCHEMA: application/json

  ### public_metadata
  object
  Metadata saved on the organization, that is visible to both your frontend and backend. The new object will be merged with the existing value.

  ### private_metadata
  object
  Metadata saved on the organization that is only visible to your backend. The new object will be merged with the existing value.
  """
  def update_metadata(id, params, opts \\ []) do
    HTTP.patch("/v1/organizations/#{id}/metadata", params, opts)
  end

  @doc """
  Set or replace an organization's logo, by uploading an image file. This endpoint uses the multipart/form-data request content type and accepts a file of image type. The file size cannot exceed 10MB. Only the following file content types are supported: image/jpeg, image/png, image/gif, image/webp, image/x-icon, image/vnd.microsoft.icon.

  ## REQUEST BODY SCHEMA: multipart/form-data
  ## uploader_user_id
  required
  string
  The ID of the user that will be credited with the image upload.

  ## file
  required
  string <binary>
  """
  def update_logo(id, logo, uploader_user_id, opts \\ []) do
    body =
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.text_field(logo, :file))
      |> Multipart.add_part(Multipart.Part.text_field(uploader_user_id, :uploader_user_id))

    HTTP.put_form("/v1/organizations/#{id}/logo", body, %{}, opts)
  end

  @doc """
  Delete the organization's logo.
  """
  def delete_logo(id, opts \\ []) do
    HTTP.delete("/v1/organizations/#{id}/logo", %{}, opts)
  end
end
