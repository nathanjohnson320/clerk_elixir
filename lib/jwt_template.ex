defmodule JWTTemplate do
  @moduledoc """
  JWT Templates allow you to generate custom authentication tokens tied to authenticated sessions, enabling you to integrate with third-party services.

  https://clerk.com/docs/request-authentication/jwt-templates
  """

  alias Clerk.HTTP

  @doc """
  Lists all JWT templates
  """
  def list(opts \\ []) do
    HTTP.get("/v1/jwt_templates", %{}, opts)
  end

  @doc """
  Create a new JWT template

  ## REQUEST BODY SCHEMA: application/json
  ### name
  string
  JWT template name

  ### claims
  object
  JWT template claims in JSON format

  ### lifetime
  number or null [ 30 .. 315360000 ]
  JWT token lifetime

  ### allowed_clock_skew
  number or null [ 0 .. 300 ]
  JWT token allowed clock skew

  ### custom_signing_key
  boolean
  Whether a custom signing key/algorithm is also provided for this template

  ### signing_algorithm
  string or null
  The custom signing algorithm to use when minting JWTs

  ### signing_key
  string or null
  The custom signing private key to use when minting JWTs
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/jwt_templates", params, opts)
  end

  @doc """
  Retrieve the details of a given JWT template
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/jwt_templates/#{id}", %{}, opts)
  end

  @doc """
  Updates an existing JWT template

  ## REQUEST BODY SCHEMA: application/json
  ### name
  string
  JWT template name

  ### claims
  object
  JWT template claims in JSON format

  ### lifetime
  number or null [ 30 .. 315360000 ]
  JWT token lifetime

  ### allowed_clock_skew
  number or null [ 0 .. 300 ]
  JWT token allowed clock skew

  ### custom_signing_key
  boolean
  Whether a custom signing key/algorithm is also provided for this template

  ### signing_algorithm
  string or null
  The custom signing algorithm to use when minting JWTs

  ### signing_key
  string or null
  The custom signing private key to use when minting JWTs
  """
  def update(id, params, opts \\ []) do
    HTTP.patch("/v1/jwt_templates/#{id}", params, opts)
  end

  @doc """
  Deletes a JWT template
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/jwt_templates/#{id}", %{}, opts)
  end
end
