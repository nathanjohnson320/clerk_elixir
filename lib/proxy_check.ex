defmodule Clerk.ProxyCheck do
  @moduledoc """
  https://clerk.com/docs/reference/backend-api/tag/Proxy-checks
  """

  @doc """
  This endpoint can be used to validate that a proxy-enabled domain is operational. It tries to verify that the proxy URL provided in the parameters maps to a functional proxy that can reach the Clerk Frontend API.

  You can use this endpoint before you set a proxy URL for a domain. This way you can ensure that switching to proxy-based configuration will not lead to downtime for your instance.

  The proxy_url parameter allows for testing proxy configurations for domains that don't have a proxy URL yet, or operate on a different proxy URL than the one provided. It can also be used to re-validate a domain that is already configured to work with a proxy.


  ## REQUEST BODY SCHEMA: application/json
  ### domain_id
  string
  The ID of the domain that will be updated.

  ### proxy_url
  string
  The full URL of the proxy which will forward requests to the Clerk Frontend API for this domain. e.g. https://example.com/__clerk
  """
  def verify(params, opts \\ []) do
    Clerk.HTTP.post("/v1/proxy_checks", params, opts)
  end
end
