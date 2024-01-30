defmodule Clerk.Miscellaneous do
  @moduledoc """
  Various endpoints that do not belong in any particular category.

  https://clerk.com/docs/reference/backend-api/tag/Miscellaneous
  """

  alias Clerk.HTTP

  @doc """
  The Clerk interstitial endpoint serves an html page that loads clerk.js in order to check the user's authentication state. It is used by Clerk SDKs when the user's authentication state cannot be immediately determined.

  ## QUERY PARAMETERS
  ### frontendApi
  string
  The Frontend API key of your instance

  ### publishable_key
  string
  The publishable key of your instance
  """
  def interstitial_markup(params, opts \\ []) do
    HTTP.get("/v1/interstitial_markup", params, opts)
  end
end
