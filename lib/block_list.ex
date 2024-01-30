defmodule Clerk.BlockList do
  alias Clerk.HTTP

  @doc """
  Get a list of all identifiers which are not allowed to access an instance
  """
  def list(opts \\ []) do
    HTTP.get("/v1/blocklist_identifiers", %{}, opts)
  end

  @doc """
  Create an identifier that is blocked from accessing an instance


  ## REQUEST BODY SCHEMA: application/json
  ### identifier
  required
  string
  The identifier to be added in the block-list. This can be an email address, a phone number or a web3 wallet.
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/blocklist_identifiers", params, %{}, opts)
  end

  @doc """
  Delete an identifier from the instance block-list
  """
  def delete(identifier, opts \\ []) do
    HTTP.delete("/v1/blocklist_identifiers/#{identifier}", %{}, opts)
  end
end
