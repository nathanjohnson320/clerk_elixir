defmodule Clerk.AuthenticationPlug do
  @moduledoc """
  Plug for authenticating requests.
  """

  @behaviour Plug

  @doc """
  Authenticates the request.
  """
  def init(opts), do: opts

  def call(conn, opts) do
    session_key = Keyword.get(opts, :session_key, "__session")
    session = Map.get(conn.req_cookies, session_key)

    with {:ok, %{"sub" => user_id} = session} <- Clerk.Session.verify_and_validate(session),
         {:ok, user} <- Clerk.User.get(user_id) do
      conn |> Plug.Conn.assign(:clerk_session, session) |> Plug.Conn.assign(:current_user, user)
    else
      {:error, _} ->
        conn
        |> Plug.Conn.send_resp(401, "Unauthorized")
        |> Plug.Conn.halt()
    end
  end
end
