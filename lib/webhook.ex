defmodule Clerk.Webhook do
  @moduledoc """
  You can configure webhooks to be notified about various events that happen on your instance.

  https://clerk.com/docs/integration/webhooks
  """
  alias Clerk.HTTP

  @doc """
  Create a Svix app and associate it with the current instance
  """
  def create(params, opts \\ []) do
    HTTP.post("/v1/webhooks/svix", params, opts)
  end

  @doc """
  Delete a Svix app and disassociate it from the current instance
  """
  def delete(id, opts \\ []) do
    HTTP.delete("/v1/webhooks/svix/#{id}", %{}, opts)
  end

  @doc """
  Generate a new url for accessing the Svix's management dashboard for that particular instance
  """
  def create_dashboard_url(params, opts \\ []) do
    HTTP.post("/v1/webhooks/svix_url", params, opts)
  end
end
