defmodule Clerk.User.Behaviour do
  @moduledoc """
  User Behaviour
  """
  alias Clerk.User.{Request, Response}

  @callback list(Request.List.t()) :: Response.List.t()
  @callback get(Request.Get.t()) :: Response.Get.t()
  @callback create(Request.Create.t()) :: Response.Create.t()
  @callback update(Request.Update.t()) :: Response.Update.t()
  @callback delete(Request.Delete.t()) :: Response.Delete.t()
end
