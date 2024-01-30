defmodule Clerk.JWKS do
  @moduledoc """
  Retrieve the JSON Web Key Set which can be used to verify the token signatures of the instance.
  """

  alias Clerk.HTTP

  @doc """
  Retrieve the JSON Web Key Set of the instance
  """
  def get(opts \\ []) do
    HTTP.get("/v1/jwks", %{}, opts)
  end
end
