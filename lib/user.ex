defmodule Clerk.User do
  alias Clerk.HTTP

  def get(user_id, opts \\ []) do
    HTTP.get("/v1/users/#{user_id}", opts)
  end
end
