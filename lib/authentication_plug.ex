defmodule Clerk.AuthenticationPlug do
  @moduledoc """
  Plug for authenticating requests.

  ## Options

    * `:session_key` - the cookie name to read the session token from.
      Defaults to `"__session"`.

    * `:fetch_user` - when `true`, fetches the full user object from the
      Clerk Backend API after token verification and assigns it as
      `:current_user`. When `false`, builds `:current_user` from the JWT
      claims alone (no network request). Defaults to `true`.

  ## Examples

      # Fetches user from Clerk API on every request (default)
      plug Clerk.AuthenticationPlug

      # Skip the API call — use JWT claims only
      plug Clerk.AuthenticationPlug, fetch_user: false
  """

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, opts) do
    session_key = Keyword.get(opts, :session_key, "__session")
    fetch_user? = Keyword.get(opts, :fetch_user, true)

    with {:ok, token} <- get_auth_token(conn, session_key),
         {:ok, %{"sub" => user_id} = claims} <- Clerk.Session.verify_and_validate(token),
         {:ok, user} <- maybe_fetch_user(user_id, claims, fetch_user?) do
      conn
      |> Plug.Conn.assign(:clerk_session, claims)
      |> Plug.Conn.assign(:current_user, user)
    else
      _ ->
        conn
        |> Plug.Conn.send_resp(401, "Unauthorized")
        |> Plug.Conn.halt()
    end
  end

  defp maybe_fetch_user(user_id, _claims, true), do: Clerk.User.get(user_id)

  defp maybe_fetch_user(_user_id, claims, false) do
    {:ok,
     %{
       "id" => claims["sub"],
       "email" => claims["email"],
       "first_name" => claims["first_name"],
       "last_name" => claims["last_name"]
     }}
  end

  defp get_auth_token(conn, session_key) do
    case get_token_from_header(conn) do
      token when is_binary(token) ->
        {:ok, token}

      nil ->
        case Map.fetch(conn.req_cookies, session_key) do
          {:ok, session} -> {:ok, session}
          _ -> {:error, :unauthorized}
        end
    end
  end

  defp get_token_from_header(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
