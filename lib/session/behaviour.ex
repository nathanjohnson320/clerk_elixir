defmodule Clerk.Session.Behaviour do
  @moduledoc """
  Defines the behaviour for the Session module.
  """

  alias Clerk.Session.{Request, Response}

  @callback get(String.t()) :: {:ok, Response.Get.t()} | {:error, any()}
  @callback get(String.t(), Keyword.t()) :: {:ok, Response.Get.t()} | {:error, any()}

  @callback list(Request.List.t()) :: {:ok, Response.List.t()} | {:error, any()}
  @callback list(Request.List.t(), Keyword.t()) :: {:ok, Response.List.t()} | {:error, any()}
end
