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

    with {:ok, session} <- get_auth_token(conn, session_key),
         {:ok, %{"sub" => user_id} = session} <- Clerk.Session.verify_and_validate(session),
         {:ok, user} <- Clerk.User.get(user_id) do
      conn |> Plug.Conn.assign(:clerk_session, session) |> Plug.Conn.assign(:current_user, user)
    else
      _ ->
        conn
        |> Plug.Conn.send_resp(401, "Unauthorized")
        |> Plug.Conn.halt()
    end
  end

  defp get_auth_token(conn, session_key) do
    auth_header = get_auth_header(conn)

    if auth_header do
      {:ok, auth_header}
    else
      case Map.fetch(conn.req_cookies, session_key) do
        {:ok, session} -> {:ok, session}
        _ -> {:error, :unauthorized}
      end
    end
  end

  defp get_auth_header(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> List.first()
    |> case do
      nil -> nil
      header -> String.replace(header, "Bearer ", "")
    end
  end

end
