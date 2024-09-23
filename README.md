# PhoenixBites

This is a real-time app that loads the SODA API San Francisco food truck data.

The api request is handled with the FoodTruckService and pulled in from https://data.sfgov.org/resource/rqzj-sfat.json.

The results from this API are ordered by the backend according to their "objectid", ordering is not natively supported by the external SODA API.

This app is real-time because it allows users to "Like" Food Trucks and the likes are propagated immediately to other users that have the site open.

Phoenix: 1.7.14
Erlang: 24.3.4.17

Realtime Demo:



https://github.com/user-attachments/assets/dae22dd6-abf6-4317-8322-2ae980c67136


Design decisions to meet 3 hour time limit:
- Maintain only a server side rendered application with no additional custom frontend javascript or frontend framework like React
- Implement direct API fetching from the San Francisco food truck SODA API
- Separation of concerns of Food Truck API functionality from the live view by establishing the FoodTruckService
- Use a Live View and iterate Live Components for all food trucks
- Use simplified Pub Sub directly in the FoodTruck Live Component 
- Listen for Websocket messages by subscribing to topic by food truck id Ex: `"food_truck_likes:#{food_truck_id}"`




To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
