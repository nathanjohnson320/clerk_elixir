defmodule Clerk.HTTP do
  @domain "https://api.clerk.com"

  def get(url, params \\ %{}, opts \\ []) do
    Finch.build(:get, url(url, params), headers(opts)) |> request()
  end

  def post(url, body, query_params \\ %{}, opts \\ []) do
    Finch.build(:post, url(url, query_params), headers(opts), Jason.encode!(body)) |> request()
  end

  defp url(path, params) do
    # Normally arrays are encoded as foo[]=bar&foo[]=baz
    # but Clerk expects foo=bar&foo=baz so we need to flatten
    # the params list before encoding
    query =
      params
      |> Enum.flat_map(fn {k, v} ->
        if is_list(v) do
          Enum.map(v, fn x -> {k, x} end)
        else
          {k, v}
        end
      end)
      |> URI.encode_query()

    "#{@domain}#{path}?#{query}"
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

  defp handle_response({:ok, %Finch.Response{status: status, body: body}})
       when status in [200, 201] do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %Finch.Response{status: 204}}) do
    {:ok, nil}
  end

  defp handle_response({:ok, %Finch.Response{status: status, body: body}})
       when status in [400, 401, 403, 404, 422] do
    {:error, Jason.decode!(body)}
  end
end
