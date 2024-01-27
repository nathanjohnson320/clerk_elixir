defmodule Clerk.HTTP do
  @domain "https://api.clerk.com"

  def get(url, opts \\ []) do
    Finch.build(:get, url(url), headers(opts)) |> request()
  end

  defp url(path) do
    "#{@domain}#{path}"
  end

  defp headers(opts) do
    headers = Keyword.get(opts, :headers, [])
    secret_key = Keyword.get(opts, :secret_key, Application.get_env(:clerk, :secret_key))

    headers ++
      [
        {"Content-Type", "application/json"},
        {"Authorization", "Bearer #{secret_key}"}
      ]
  end

  defp request(req) do
    req |> Finch.request(ClerkHTTP) |> handle_response()
  end

  defp handle_response({:ok, %Finch.Response{status: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 201, body: body}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 204}}) do
    {:ok, nil}
  end

  defp handle_response({:ok, %Finch.Response{status: 400, body: body}}) do
    {:error, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 401, body: body}}) do
    {:error, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 403, body: body}}) do
    {:error, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 404, body: body}}) do
    {:error, Jason.decode!(body)}
  end
end
