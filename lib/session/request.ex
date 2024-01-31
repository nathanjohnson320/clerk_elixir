defmodule Clerk.Session.Request do
  defmodule List do
    defstruct [:client_id, :user_id, :status, limit: 10, offset: 0]
  end
end
