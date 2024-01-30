defmodule Clerk.EmailAddress do
  @moduledoc """
  A user can be associated with one or more email addresses and allows them to be contacted via email.

  https://clerk.com/docs/reference/clerkjs/emailaddress
  """
  alias Clerk.HTTP

  @doc """
  Create a new email address

  ## REQUEST BODY SCHEMA: application/json
  ### user_id
  string
  The ID representing the user

  ### email_address
  string
  The new email address. Must adhere to the RFC 5322 specification for email address format.

  ### verified
  boolean or null
  When created, the email address will be marked as verified.

  ### primary
  boolean or null
  Create this email address as the primary email address for the user. Default: false, unless it is the first email address.
  """

  def create(params, opts \\ []) do
    HTTP.post("/v1/email_addresses", params, %{}, opts)
  end

  @doc """
  Returns the details of an email address.
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/email_addresses/#{id}", %{}, opts)
  end

  @doc """
  Delete the email address with the given ID
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/email_addresses/#{id}", %{}, opts)
  end

  @doc """
  Updates an email address.

  ## REQUEST BODY SCHEMA: application/json
  ### verified
  boolean or null
  The email address will be marked as verified.

  ### primary
  boolean or null
  Set this email address as the primary email address for the user.
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/email_addresses/#{id}", params, %{}, opts)
  end
end
