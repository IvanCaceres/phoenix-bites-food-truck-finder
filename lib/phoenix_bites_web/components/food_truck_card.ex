defmodule PhoenixBitesWeb.FoodTruckCard do
  use Phoenix.LiveComponent

  alias Phoenix.PubSub

  # Create a unique topic for each food truck
  defp topic(food_truck_id), do: "food_truck_likes:#{food_truck_id}"

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)

    # Only subscribe once: check if we have already subscribed, otherwise subscribe and mark it as subscribed
    if not Map.get(socket.assigns, :subscribed?, false) do
      Phoenix.PubSub.subscribe(PhoenixBites.PubSub, topic(socket.assigns.id))
      IO.puts("Subscribed to topic #{topic(socket.assigns.id)}")

      # Mark the component as subscribed
      socket = assign(socket, :subscribed?, true)
    end

    # Ensure :likes is set (initialize it to 0 if not set)
    {:ok, assign_new(socket, :likes, fn -> 0 end)}
  end

  def mount() do
    IO.puts("component mounted")
  end

  @impl true
  def handle_event("like", _params, socket) do
    # Increment likes
    new_likes = socket.assigns.likes + 1

    # Log the PubSub broadcast
    IO.puts(
      "Broadcasting to topic: #{topic(socket.assigns.id)} new likes count: #{new_likes} for food truck id: #{socket.assigns.id}"
    )

    # Broadcast the new likes count to all clients
    PubSub.broadcast_from(
      PhoenixBites.PubSub,
      self(),
      topic(socket.assigns.id),
      {:new_likes, socket.assigns.id, new_likes}
    )

    {:noreply, assign(socket, likes: new_likes)}
  end

  @impl true
  @spec handle_info(
          {:new_likes, any(), any()},
          atom()
          | %{
              :assigns => atom() | %{:id => any(), optional(any()) => any()},
              optional(any()) => any()
            }
        ) :: {:noreply, any()}
  def handle_info({:new_likes, id, new_likes}, socket) do
    # Log when a component receives a PubSub message
    IO.puts("Received PubSub message: new likes count #{new_likes} for food truck id: #{id}")

    if socket.assigns.id == id do
      {:noreply, assign(socket, likes: new_likes)}
    else
      {:noreply, socket}
    end
  end
end
