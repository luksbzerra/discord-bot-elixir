defmodule DiscordBotElixirTest do
  use ExUnit.Case
  doctest DiscordBotElixir

  test "greets the world" do
    assert DiscordBotElixir.hello() == :world
  end
end
