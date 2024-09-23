defmodule PhoenixBites.Repo do
  @otp_app :phoenix_bites

  # Define the child_spec/1 function
  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }
  end

  # Implement a simple start_link function
  def start_link(_opts \\ []) do
    # Return {:ok, self()} for now
    {:ok, self()}
  end
end
