defmodule Clerk.Domain do
  @moduledoc """
  Domains represent each instance's URLs and DNS setup.
  """
  alias Clerk.HTTP

  @doc """
  Use this endpoint to get a list of all domains for an instance. The response will contain the primary domain for the instance and any satellite domains. Each domain in the response contains information about the URLs where Clerk operates and the required CNAME targets.
  """
  def list(opts \\ []) do
    HTTP.get("/v1/domains", %{}, opts)
  end

  @doc """
  ## REQUEST BODY SCHEMA: application/json
  ### name
  required
  string
  The new domain name. Can contain the port for development instances.

  ### is_satellite
  required
  boolean
  Marks the new domain as satellite. Only true is accepted at the moment.
  Value: true

  ### proxy_url
  string
  The full URL of the proxy which will forward requests to the Clerk Frontend API for this domain. Applicable only to production instances.
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/domains", params, %{}, opts)
  end

  @doc """
  Deletes a satellite domain for the instance. It is currently not possible to delete the instance's primary domain.
  """
  def delete(domain_id, opts \\ []) do
    HTTP.delete("/v1/domains/#{domain_id}", %{}, opts)
  end

  @doc """
  The proxy_url can be updated only for production instances. Update one of the instance's domains. Both primary and satellite domains can be updated. If you choose to use Clerk via proxy, use this endpoint to specify the proxy_url. Whenever you decide you'd rather switch to DNS setup for Clerk, simply set proxy_url to null for the domain. When you update a production instance's primary domain name, you have to make sure that you've completed all the necessary setup steps for DNS and emails to work. Expect downtime otherwise. Updating a primary domain's name will also update the instance's home origin, affecting the default application paths.

  ## REQUEST BODY SCHEMA: application/json
  required
  ### name
  string or null
  The new domain name. For development instances, can contain the port, i.e myhostname:3000. For production instances, must be a valid FQDN, i.e mysite.com. Cannot contain protocol scheme.

  ### proxy_url
  string or null
  The full URL of the proxy that will forward requests to Clerk's Frontend API. Can only be updated for production instances.
  """
  def update(domain_id, params, opts \\ []) do
    HTTP.patch("/v1/domains/#{domain_id}", params, %{}, opts)
  end
end
