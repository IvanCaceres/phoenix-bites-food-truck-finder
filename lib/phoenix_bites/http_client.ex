defmodule PhoenixBites.HttpClient do
  @callback get(String.t()) ::
              {:ok, %{status_code: integer(), body: String.t()}} | {:error, any()}
end
