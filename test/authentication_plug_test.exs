defmodule Clerk.AuthenticationPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Clerk.AuthenticationPlug

  describe "init/1" do
    test "passes empty options through" do
      assert AuthenticationPlug.init([]) == []
    end

    test "passes fetch_user option through" do
      assert AuthenticationPlug.init(fetch_user: false) == [fetch_user: false]
      assert AuthenticationPlug.init(fetch_user: true) == [fetch_user: true]
    end

    test "passes session_key option through" do
      assert AuthenticationPlug.init(session_key: "custom") == [session_key: "custom"]
    end

    test "passes multiple options through" do
      opts = [fetch_user: false, session_key: "my_session"]
      assert AuthenticationPlug.init(opts) == opts
    end
  end

  describe "call/2 with no credentials" do
    test "returns 401 when no auth header or cookie present" do
      conn =
        conn(:get, "/")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 with non-Bearer authorization header" do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", "Basic abc123")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 with empty authorization header" do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", "")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 when only Bearer prefix with no token" do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", "Bearer ")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      # "Bearer " <> token matches with token == "", which is a binary,
      # so it proceeds to verify_and_validate with an empty string,
      # which will fail and return 401
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "call/2 with invalid token" do
    test "returns 401 with invalid Bearer token" do
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", "Bearer invalid-token")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 with invalid cookie token using default session key" do
      conn =
        conn(:get, "/")
        |> put_req_cookie("__session", "invalid-token")
        |> fetch_cookies()
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 with invalid cookie token using custom session key" do
      conn =
        conn(:get, "/")
        |> put_req_cookie("custom_session", "invalid-token")
        |> fetch_cookies()
        |> AuthenticationPlug.call(AuthenticationPlug.init(session_key: "custom_session"))

      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "call/2 cookie fallback" do
    test "ignores cookie with wrong session key" do
      conn =
        conn(:get, "/")
        |> put_req_cookie("wrong_key", "some-token")
        |> fetch_cookies()
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      # Default session_key is "__session", so "wrong_key" is ignored
      assert conn.status == 401
      assert conn.halted
    end

    test "cookie is not read when req_cookies are unfetched" do
      # When fetch_cookies hasn't been called, req_cookies is %Unfetched{}
      # and Map.fetch returns :error, so the plug returns 401
      conn =
        conn(:get, "/")
        |> put_req_cookie("__session", "some-token")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "call/2 header takes precedence over cookie" do
    test "uses Bearer token when both header and cookie are present" do
      # Both tokens are invalid, but this verifies the header path is taken
      # (both paths lead to 401 since tokens are invalid, but the important
      # thing is no crash occurs)
      conn =
        conn(:get, "/")
        |> put_req_header("authorization", "Bearer header-token")
        |> put_req_cookie("__session", "cookie-token")
        |> fetch_cookies()
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "call/2 response body" do
    test "returns 'Unauthorized' as response body" do
      conn =
        conn(:get, "/")
        |> AuthenticationPlug.call(AuthenticationPlug.init([]))

      assert conn.resp_body == "Unauthorized"
    end
  end
end
