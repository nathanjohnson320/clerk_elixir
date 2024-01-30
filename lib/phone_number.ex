defmodule Clerk.PhoneNumber do
  @moduledoc """
  A user can be associated with one or more email addresses and allows them to be contacted via SMS.

  https://clerk.com/docs/reference/clerkjs/phonenumber
  """

  alias Clerk.HTTP

  @doc """
  Create a new phone number

  ## REQUEST BODY SCHEMA: application/json
  ### user_id
  string
  The ID representing the user

  ### phone_number
  string
  The new phone number. Must adhere to the E.164 standard for phone number format.

  ### verified
  boolean or null
  When created, the phone number will be marked as verified.

  ### primary
  boolean or null
  Create this phone number as the primary phone number for the user. Default: false, unless it is the first phone number.


  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/phone_numbers", params, opts)
  end

  @doc """
  Returns the details of a phone number
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/phone_numbers/#{id}", %{}, opts)
  end

  @doc """
  Delete the phone number with the given ID
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/phone_numbers/#{id}", %{}, opts)
  end

  @doc """
  Updates a phone number

  ## REQUEST BODY SCHEMA: application/json
  ### verified
  boolean or null
  The phone number will be marked as verified.

  ### primary
  boolean or null
  Set this phone number as the primary phone number for the user.
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/phone_numbers/#{id}", params, opts)
  end
end
