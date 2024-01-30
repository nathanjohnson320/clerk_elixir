defmodule Clerk.SAMLConnection do
  @moduledoc """
  A SAML Connection holds configuration data required for facilitating a SAML flow between your Clerk Instance (SP) and a particular SAML IdP.
  """
  alias Clerk.HTTP

  @doc """
  Returns the list of SAML Connections for an instance. Results can be paginated using the optional limit and offset query parameters. The SAML Connections are ordered by descending creation date and the most recent will be returned first.
  Refer to https://clerk.com/docs/authentication/saml-at-clerk#saml-at-clerk-beta for more information.

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
  def list(opts \\ []) do
    HTTP.get("/v1/saml_connections", %{}, opts)
  end

  @doc """
  Refer to https://clerk.com/docs/authentication/saml-at-clerk#saml-at-clerk-beta for more information.

  ## REQUEST BODY SCHEMA: application/json
  ### name
  required
  string
  The name to use as a label for this SAML Connection

  ### domain
  required
  string
  The domain of your organization. Sign in flows using an email with this domain, will use this SAML Connection.

  ### idp_entity_id
  string or null
  The Entity ID as provided by the IdP

  ### idp_sso_url
  string or null
  The Single-Sign On URL as provided by the IdP

  ### idp_certificate
  string or null
  The X.509 certificate as provided by the IdP
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/saml_connections", params, opts)
  end

  @doc """
  Fetches the SAML Connection whose ID matches the provided saml_connection_id in the path.
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/saml_connections/#{id}", %{}, opts)
  end

  @doc """
  Updates the SAML Connection whose ID matches the provided id in the path.

  ## REQUEST BODY SCHEMA: application/json

  ### name
  string or null
  The name of the new SAML Connection

  ### domain
  string or null
  The domain to use for the new SAML Connection

  ### idp_entity_id
  string or null
  The entity id as provided by the IdP

  ### idp_sso_url
  string or null
  The SSO url as provided by the IdP

  ### idp_certificate
  string or null
  The x509 certificated as provided by the IdP

  ### active
  boolean or null
  Activate or de-activate the SAML Connection

  ### sync_user_attributes
  boolean or null
  Controls whether to update the user's attributes in each sign-in
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/saml_connections/#{id}", params, opts)
  end

  @doc """
  Deletes the SAML Connection whose ID matches the provided id in the path.
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/saml_connections/#{id}", %{}, opts)
  end
end
