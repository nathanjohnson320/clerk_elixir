defmodule Clerk.Instance do
  @moduledoc false

  @table :clerk_instances

  @type t :: %{
          domain: String.t(),
          http_name: atom(),
          secret_key: String.t() | nil,
          fetching_strategy: module(),
          authorized_parties: [String.t()] | nil
        }

  def register(name, config) when is_atom(name) and is_map(config) do
    ensure_table()
    :ets.insert(@table, {name, config})
    :ok
  end

  def unregister(name) when is_atom(name) do
    case :ets.info(@table) do
      :undefined ->
        :ok

      _ ->
        :ets.delete(@table, name)
        :ok
    end
  end

  def get(name \\ Clerk) when is_atom(name) do
    ensure_table()

    case :ets.lookup(@table, name) do
      [{^name, config}] ->
        config

      [] ->
        %{
          domain: Application.get_env(:clerk, :domain),
          http_name: ClerkHTTP,
          secret_key: Application.get_env(:clerk, :secret_key),
          fetching_strategy: Clerk.Session.FetchingStrategy,
          authorized_parties: Application.get_env(:clerk, :authorized_parties)
        }
    end
  end

  defp ensure_table do
    case :ets.info(@table) do
      :undefined ->
        :ets.new(@table, [
          :named_table,
          :set,
          :public,
          read_concurrency: true,
          write_concurrency: true
        ])

      _ ->
        :ok
    end
  end

  defmodule Cleanup do
    @moduledoc false
    use GenServer

    def start_link(opts) do
      GenServer.start_link(__MODULE__, opts)
    end

    @impl true
    def init(opts) do
      {:ok, Keyword.fetch!(opts, :instance)}
    end

    @impl true
    def terminate(_reason, instance) do
      Clerk.Instance.unregister(instance)
      :ok
    end
  end
end
