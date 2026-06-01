defmodule Clerk.HTTP do
  @domain "https://api.clerk.com"

  def get(url, params \\ %{}, opts \\ []) do
    :get |> Finch.build(url(url, params), headers(opts)) |> request(opts)
  end

  def post(url, body, query_params \\ %{}, opts \\ []) do
    :post
    |> Finch.build(url(url, query_params), headers(opts), Jason.encode!(body))
    |> request(opts)
  end

  def post_form(url, multipart, query_params \\ %{}, opts \\ []) do
    content_type = Multipart.content_type(multipart, "multipart/form-data")
    opts = Keyword.put(opts, :content_type, content_type)

    :post
    |> Finch.build(
      url(url, query_params),
      headers(opts),
      {:stream, Multipart.body_stream(multipart)}
    )
    |> request(opts)
  end

  def put_form(url, multipart, query_params \\ %{}, opts \\ []) do
    content_type = Multipart.content_type(multipart, "multipart/form-data")
    opts = Keyword.put(opts, :content_type, content_type)

    :put
    |> Finch.build(
      url(url, query_params),
      headers(opts),
      {:stream, Multipart.body_stream(multipart)}
    )
    |> request(opts)
  end

  def patch(url, body, query_params \\ %{}, opts \\ []) do
    :patch
    |> Finch.build(url(url, query_params), headers(opts), Jason.encode!(body))
    |> request(opts)
  end

  def put(url, body, query_params \\ %{}, opts \\ []) do
    :put
    |> Finch.build(url(url, query_params), headers(opts), Jason.encode!(body))
    |> request(opts)
  end

  def delete(url, query_params \\ %{}, opts \\ []) do
    :delete |> Finch.build(url(url, query_params), headers(opts)) |> request(opts)
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
          [{k, v}]
        end
      end)
      |> URI.encode_query()

    "#{@domain}#{path}?#{query}"
  end

  defp headers(opts) do
    config = config(opts)
    headers = Keyword.get(opts, :headers, [])
    content_type = Keyword.get(opts, :content_type, "application/json")
    secret_key = Keyword.get(opts, :secret_key, config.secret_key)

    headers ++
      [
        {"Content-Type", content_type},
        {"Authorization", "Bearer #{secret_key}"}
      ]
  end

  defp request(req, opts) do
    http_name = config(opts).http_name
    req |> Finch.request(http_name) |> handle_response()
  end

  defp config(opts) do
    case Keyword.get(opts, :config) do
      %Clerk.Config{} = config -> config
      nil -> Clerk.Config.from_application_env()
    end
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
