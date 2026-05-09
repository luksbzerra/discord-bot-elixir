defmodule DiscordBotElixir.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api.Message
  alias DiscordBotElixir.Commands

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    IO.inspect(msg.content)

    is_bot =
      Map.get(msg.author, :bot, false)

    if is_bot != true do
      content =
        String.trim(msg.content)

      handle_message(content, msg)
    end
  end

  def handle_message("!ping", msg) do
  result =
    Message.create(msg.channel_id, "🏓 Pong! Bot funcionando.")

  IO.inspect(result, label: "RESULTADO DO ENVIO")
end

  def handle_message("!cachorro", msg) do
    Message.create(msg.channel_id, Commands.cachorro())
  end

  def handle_message("!lembretes", msg) do
    response =
      Commands.lembretes(msg.author.id)

    Message.create(msg.channel_id, response)
  end

  def handle_message(message, msg) when is_binary(message) do
    case String.split(message) do
      ["!clima" | city_parts] ->
        city = Enum.join(city_parts, " ")
        response = Commands.clima(city)
        Message.create(msg.channel_id, response)

      ["!cep", cep] ->
        response = Commands.cep(cep)
        Message.create(msg.channel_id, response)

      ["!conv", value, from, to] ->
        response = Commands.conv(value, from, to)
        Message.create(msg.channel_id, response)

      ["!numero", number, type] ->
        response = Commands.numero(number, type)
        Message.create(msg.channel_id, response)

      ["!lembrar" | text_parts] ->
        text = Enum.join(text_parts, " ")

        response =
          Commands.lembrar(msg.author.id, text)

        Message.create(msg.channel_id, response)

      ["!curiosidade" | city_parts] ->
        city = Enum.join(city_parts, " ")
        response = Commands.curiosidade(city)
        Message.create(msg.channel_id, response)

      _ ->
        :ignore
    end
  end
end