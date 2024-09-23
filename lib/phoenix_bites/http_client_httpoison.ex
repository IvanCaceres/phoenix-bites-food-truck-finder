defmodule PhoenixBites.HttpClientHTTPoison do
  @behaviour PhoenixBites.HttpClient

  @impl true
  def get(url) do
    HTTPoison.get(url)
  end
end
