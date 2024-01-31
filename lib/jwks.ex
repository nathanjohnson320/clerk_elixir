defmodule Clerk.JWKS do
  @moduledoc """
  Retrieve the JSON Web Key Set which can be used to verify the token signatures of the instance.
  """

  alias Clerk.HTTP
  alias Clerk.JWKS.{Behaviour, Response}

  @behaviour Behaviour

  @doc """
  Retrieve the JSON Web Key Set of the instance
  """
  @impl Behaviour
  def get(opts \\ []) do
    HTTP.get("/v1/jwks", %{}, opts, Response.Get)
  end
end
