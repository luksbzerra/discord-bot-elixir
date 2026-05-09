defmodule DiscordBotElixir.Store do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, load(), name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def add_reminder(user_id, text) do
    GenServer.call(__MODULE__, {:add_reminder, user_id, text})
  end

  def list_reminders(user_id) do
    GenServer.call(__MODULE__, {:list_reminders, user_id})
  end

  def handle_call({:add_reminder, user_id, text}, _from, state) do
    user_key = to_string(user_id)

    updated_state =
      Map.update(state, user_key, [text], fn reminders ->
        reminders ++ [text]
      end)

    save(updated_state)

    {:reply, :ok, updated_state}
  end

  def handle_call({:list_reminders, user_id}, _from, state) do
    user_key = to_string(user_id)

    reminders =
      Map.get(state, user_key, [])

    {:reply, reminders, state}
  end

  defp load do
    case File.read("reminders.json") do
      {:ok, content} ->
        Jason.decode!(content)

      {:error, _} ->
        %{}
    end
  end

  defp save(state) do
    json = Jason.encode!(state, pretty: true)

    File.write!(
      "reminders.json",
      json
    )
  end
end