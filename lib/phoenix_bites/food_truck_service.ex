defmodule PhoenixBites.FoodTruckService do
  @moduledoc """
  A service module for interacting with external APIs to retrieve food truck data.
  """

  alias HTTPoison
  alias Jason

  # SODA API Endpoint for open San Francisco food truck data
  @api_url "https://data.sfgov.org/resource/rqzj-sfat.json"

  @doc """
  Fetches the list of food trucks from the external API.
  Returns {:ok, food_trucks} on success, or {:error, reason} on failure.
  """
  def get_food_trucks do
    case HTTPoison.get(@api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, food_trucks} -> {:ok, food_trucks}
          {:error, _reason} -> {:error, :invalid_response}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, {:bad_status, status_code}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
