defmodule Clerk.JWKS.Response do
  defmodule Get do
    defstruct [:keys]

    defmodule Key do
      defstruct [:alg, :e, :kid, :kty, :n, :use]

      def new(key) do
        %__MODULE__{
          alg: key["alg"],
          e: key["e"],
          kid: key["kid"],
          kty: key["kty"],
          n: key["n"],
          use: key["use"]
        }
      end
    end

    def new(jwks) do
      keys =
        jwks
        |> Map.get("keys", [])
        |> Enum.map(fn key ->
          Key.new(key)
        end)

      %__MODULE__{keys: keys}
    end
  end
end
