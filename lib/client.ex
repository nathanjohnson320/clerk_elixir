defmodule Clerk.Client do
  @moduledoc """
  The Client object tracks sessions, as well as the state of any sign in and sign up attempts, for a given device.
  https://clerk.com/docs/reference/clerkjs/client
  """
  alias Clerk.HTTP

  @doc """
  Verifies the client in the provided token
  """
  def verify(token, opts \\ []) do
    HTTP.post("/v1/tokens/verify", %{"token" => token}, %{}, opts)
  end

  @doc """
  Returns the details of a client.
  """
  def get(id, opts \\ []) do
    HTTP.get("/v1/clients/#{id}", %{}, opts)
  end
end
