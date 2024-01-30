defmodule Clerk.AllowList do
  alias Clerk.HTTP

  @doc """
  Get a list of all identifiers allowed to sign up to an instance
  """
  def list(opts \\ []) do
    HTTP.get("/v1/allowlist_identifiers", %{}, opts)
  end

  @doc """
  Create an identifier allowed to sign up to an instance

  ## REQUEST BODY SCHEMA: application/json
  ### identifier
  required
  string
  The identifier to be added in the allow-list. This can be an email address, a phone number or a web3 wallet.

  ### notify
  boolean
  Default: false
  This flag denotes whether the given identifier will receive an invitation to join the application. Note that this only works for email address and phone number identifiers.
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/allowlist_identifiers", params, %{}, opts)
  end

  @doc """
  Delete an identifier from the instance allow-list
  """
  def delete(identifier, opts \\ []) do
    HTTP.delete("/v1/allowlist_identifiers/#{identifier}", %{}, opts)
  end
end
