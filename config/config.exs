import Config

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: [
    :guild_messages,
    :message_content
  ],
  ffmpeg: false