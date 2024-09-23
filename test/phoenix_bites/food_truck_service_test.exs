defmodule PhoenixBites.FoodTruckServiceTest do
  use ExUnit.Case, async: true
  import Mox

  alias PhoenixBites.FoodTruckService
  alias PhoenixBites.HttpClientMock

  setup :verify_on_exit!

  describe "get_food_trucks/1" do
    test "returns {:ok, food trucks} on a successful API call" do
      # Mock the successful HTTPoison response
      expect(HttpClientMock, :get, fn _url ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             Jason.encode!([
               %{"applicant" => "Food Truck 1", "location" => "123 Main St"},
               %{"applicant" => "Food Truck 2", "location" => "456 Park Ave"}
             ])
         }}
      end)

      # Call the function with the mock
      assert {:ok, food_trucks} = FoodTruckService.get_food_trucks(HttpClientMock)

      # Check the expected output
      assert length(food_trucks) == 2

      assert food_trucks == [
               %{"applicant" => "Food Truck 1", "location" => "123 Main St"},
               %{"applicant" => "Food Truck 2", "location" => "456 Park Ave"}
             ]
    end

    test "returns {:error, :invalid_response} on JSON decode error" do
      # Mock the API call with an invalid JSON response
      expect(HttpClientMock, :get, fn _url ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: "invalid_json"
         }}
      end)

      # Call the function and expect an error
      assert {:error, :invalid_response} = FoodTruckService.get_food_trucks(HttpClientMock)
    end

    test "returns {:error, {:bad_status, status_code}} on non-200 status code" do
      # Mock the API call returning a non-200 status code
      expect(HttpClientMock, :get, fn _url ->
        {:ok,
         %HTTPoison.Response{
           status_code: 404,
           body: "Not Found"
         }}
      end)

      # Call the function and check for error with status code
      assert {:error, {:bad_status, 404}} = FoodTruckService.get_food_trucks(HttpClientMock)
    end

    test "returns {:error, reason} on HTTP request error" do
      # Mock the HTTPoison error
      expect(HttpClientMock, :get, fn _url ->
        {:error, %HTTPoison.Error{reason: :timeout}}
      end)

      # Call the function and check for timeout error
      assert {:error, :timeout} = FoodTruckService.get_food_trucks(HttpClientMock)
    end
  end
end
