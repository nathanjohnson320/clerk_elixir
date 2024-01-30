defmodule Clerk.RedirectURL do
  @moduledoc """
  Redirect URLs are whitelisted URLs that facilitate secure authentication flows in native applications (e.g. React Native, Expo). In these contexts, Clerk ensures that security-critical nonces are passed only to the whitelisted URLs.
  """

  alias Clerk.HTTP

  @doc """
  Lists all whitelisted redirect_urls for the instance
  """
  def list(opts \\ []) do
    HTTP.get("/v1/redirect_urls", %{}, opts)
  end

  @doc """
  Create a redirect URL

  ## REQUEST BODY SCHEMA: application/json

  ### url
  string
  The full url value prefixed with https:// or a custom scheme e.g. "https://my-app.com/oauth-callback" or "my-app://oauth-callback"
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/redirect_urls", params, opts)
  end

  @doc """
  Retrieve the details of the redirect URL with the given ID
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/redirect_urls/#{id}", %{}, opts)
  end

  @doc """
  Remove the selected redirect URL from the whitelist of the instance
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/redirect_urls/#{id}", %{}, opts)
  end
end
