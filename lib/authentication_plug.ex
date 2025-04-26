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

    with {:ok, session} <- Map.fetch(conn.req_cookies, session_key),
         {:ok, %{"sub" => user_id} = session} <- Clerk.Session.verify_and_validate(session),
         {:ok, user} <- get_user(user_id) do
      conn |> Plug.Conn.assign(:clerk_session, session) |> Plug.Conn.assign(:current_user, user)
    else
      _ ->
        conn
        |> Plug.Conn.send_resp(401, "Unauthorized")
        |> Plug.Conn.halt()
    end
  end


  # private function to get the user from Clerk. If the user is not found, it will return an error.
  # Also includes a message to the console if the user is not found. Hopefully it will guide the user
  # if they have not setup the domain and secret key properly.
  # 👇
  defp get_user(user_id) do
    case Clerk.User.get(user_id) do
      {:ok, user} -> {:ok, user}
      {:error, _} ->
        IO.puts("Error fetching the user from Clerk (have you set the domain, and secret key?)")
        {:error, :user_not_found}
    end
  end

end
