defmodule PhoenixBitesWeb.HomeLive do
  use PhoenixBitesWeb, :live_view
  alias PhoenixBites.FoodTruckService
  alias PhoenixBitesWeb.FoodTruckCard

  # Import the LiveView helpers to use live_component/3
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveComponent

  embed_templates "../components/*"

  @impl true
  def mount(_params, _session, socket) do
    # Use the service to fetch food trucks
    case FoodTruckService.get_food_trucks() do
      {:ok, food_trucks} ->
        # Sort the food trucks by the "applicant" field
        sorted_food_trucks = Enum.sort_by(food_trucks, fn truck -> truck["objectid"] end)

        # Assign the sorted list to the socket
        {:ok, assign(socket, :food_trucks, sorted_food_trucks)}

      {:error, _reason} ->
        # Handle error case
        {:ok, assign(socket, :food_trucks, [])}
    end
  end

  @impl true
  def handle_info({:new_likes, id, new_likes}, socket) do
    IO.puts(
      "HomeLive received PubSub message: new likes count #{new_likes} for food truck id: #{id}"
    )

    # Trigger the LiveComponents to update their state via temporary assigns or broadcasts
    # You can trigger an event or use a method like `send_update/3` to update the component.
    send_update(PhoenixBitesWeb.FoodTruckCard, id: id, likes: new_likes)

    {:noreply, socket}
  end
end
