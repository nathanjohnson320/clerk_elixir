defmodule Clerk.JWKS.Behaviour do
  @moduledoc """
  Defines the behaviour for the JWKS module.
  """

  alias Clerk.JWKS.Get

  @callback get() :: {:ok, Get.Response.t()} | {:error, any()}
  @callback get(Keyword.t()) :: {:ok, Get.Response.t()} | {:error, any()}
end
