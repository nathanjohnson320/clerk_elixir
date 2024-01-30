defmodule Clerk.OAuthApplication do
  @moduledoc """
  OAuth applications contain data for clients using Clerk as an OAuth2 identity provider.
  """

  alias Clerk.HTTP

  @doc """
  This request returns the list of OAuth applications for an instance. Results can be paginated using the optional limit and offset query parameters. The OAuth applications are ordered by descending creation date. Most recent OAuth applications will be returned first.

  ## QUERY PARAMETERS
  ### limit
  number [ 1 .. 500 ]
  Default: 10
  Applies a limit to the number of results returned. Can be used for paginating the results together with offset. Must be an integer greater than zero and less than 500. By default, if not supplied, a limit of 10 is used.

  ### offset
  number >= 0
  Default: 0
  Skip the first offset results when paginating. Needs to be an integer greater or equal to zero. To be used in conjunction with limit.
  """
  def list(params \\ %{}, opts \\ []) do
    HTTP.get("/v1/oauth_applications", params, opts)
  end

  @doc """
  Creates a new OAuth application with the given name and callback URL for an instance. The callback URL must be a valid url. All URL schemes are allowed such as http://, https://, myapp://, etc...

  ## REQUEST BODY SCHEMA: application/json
  ### name
  required
  string
  The name of the new OAuth application

  ### callback_url
  required
  string
  The callback URL of the new OAuth application

  ### scopes
  string
  Default: "profile email"
  Define the allowed scopes for the new OAuth applications that dictate the user payload of the OAuth user info endpoint. Available scopes are profile, email, public_metadata, private_metadata. Provide the requested scopes as a string, separated by spaces.

  ### public
  boolean
  If true, this client is public and cannot securely store a client secret. Only the authorization code flow with proof key for code exchange (PKCE) may be used. Public clients cannot be updated to be confidential clients, and vice versa.
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/oauth_applications", params, opts)
  end

  @doc """
  Fetches the OAuth application whose ID matches the provided id in the path.
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/oauth_applications/#{id}", %{}, opts)
  end

  @doc """
  Updates an existing OAuth application

  ## REQUEST BODY SCHEMA: application/json
  required
  ### name
  string
  The new name of the OAuth application

  ### callback_url
  string
  The new callback URL of the OAuth application

  ### scopes
  string
  Default: "profile email"
  Define the allowed scopes for the new OAuth applications that dictate the user payload of the OAuth user info endpoint. Available scopes are profile, email, public_metadata, private_metadata. Provide the requested scopes as a string, separated by spaces.
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/oauth_applications/#{id}", params, opts)
  end

  @doc """
  Deletes the given OAuth application. This is not reversible.
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/oauth_applications/#{id}", %{}, opts)
  end

  @doc """
  Rotates the OAuth application's client secret. When the client secret is rotated, make sure to update it in authorized OAuth clients.
  """
  def rotate_secret(id, opts \\ []) do
    HTTP.post("/v1/oauth_applications/#{id}/rotate_secret", %{}, opts)
  end
end
