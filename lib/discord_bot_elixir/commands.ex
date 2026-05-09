defmodule DiscordBotElixir.Commands do
  alias DiscordBotElixir.Store

  def ping do
    "🏓 Pong! Bot funcionando."
  end

  def clima(city) do
    city_encoded = URI.encode(city)

    geo_url =
      "https://geocoding-api.open-meteo.com/v1/search?name=#{city_encoded}&count=1&language=pt&format=json"

    with {:ok, geo_response} <- HTTPoison.get(geo_url),
         {:ok, geo_data} <- Jason.decode(geo_response.body),
         %{"results" => [location | _]} <- geo_data do

      latitude = location["latitude"]
      longitude = location["longitude"]
      name = location["name"]

      weather_url =
        "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current_weather=true"

      with {:ok, weather_response} <- HTTPoison.get(weather_url),
           {:ok, weather_data} <- Jason.decode(weather_response.body),
           %{"current_weather" => weather} <- weather_data do

        temperature = weather["temperature"]
        windspeed = weather["windspeed"]

        "🌤️ Clima em #{name}: #{temperature}°C, vento #{windspeed} km/h."
      else
        _ -> "Não consegui buscar o clima dessa cidade."
      end
    else
      _ -> "Cidade não encontrada."
    end
  end

  def cep(cep) do
    url = "https://viacep.com.br/ws/#{cep}/json/"

    case HTTPoison.get(url) do
      {:ok, response} ->
        data = Jason.decode!(response.body)

        if Map.has_key?(data, "erro") do
          "CEP não encontrado."
        else
          "#{data["logradouro"]}, #{data["bairro"]}, #{data["localidade"]} - #{data["uf"]}"
        end

      _ ->
        "Erro ao consultar CEP."
    end
  end

  def conv(value, from, to) do
  from = String.upcase(from)
  to = String.upcase(to)

  url =
    "https://open.er-api.com/v6/latest/#{from}"

  case HTTPoison.get(url) do
    {:ok, %{status_code: 200, body: body}} ->
      data = Jason.decode!(body)

      rate =
        data["rates"]
        |> Map.get(to)

      if rate == nil do
        "Moeda não encontrada."
      else
        value_float =
  value
  |> Float.parse()
  |> elem(0)

        result =
          value_float * rate

        "💱 #{value} #{from} = #{Float.round(result, 2)} #{to}"
      end

    _ ->
      "Erro ao converter moeda."
  end
end

  def numero(number, _type) do
  url = "https://api.math.tools/numbers/nod?number=#{number}"

  case HTTPoison.get(url) do
    {:ok, %{status_code: 200, body: body}} ->
      data = Jason.decode!(body)

      text =
        data
        |> get_in(["contents", "nod", "numbers", "names", "cardinal", "us"])

      if text == nil do
        "🔢 Número #{number}: não encontrei uma curiosidade."
      else
        "🔢 O número #{number} por extenso é: #{text}"
      end

    _ ->
      "Erro ao consultar API de números."
  end
end

  def cachorro do
    url = "https://dog.ceo/api/breeds/image/random"

    case HTTPoison.get(url) do
      {:ok, response} ->
        data = Jason.decode!(response.body)
        "🐶 #{data["message"]}"

      _ ->
        "Erro ao buscar imagem de cachorro."
    end
  end

  def lembrar(user_id, text) do
    Store.add_reminder(user_id, text)

    "📝 Anotado! Vou me lembrar disso."
  end

  def lembretes(user_id) do
    reminders = Store.list_reminders(user_id)

    if Enum.empty?(reminders) do
      "Você ainda não tem lembretes salvos."
    else
      reminders_text =
        reminders
        |> Enum.with_index(1)
        |> Enum.map(fn {reminder, index} -> "#{index}. #{reminder}" end)
        |> Enum.join("\n")

      "📌 Seus lembretes:\n#{reminders_text}"
    end
  end

  def curiosidade(city) do
  city_encoded =
    URI.encode(city)

  url =
    "https://geocoding-api.open-meteo.com/v1/search?name=#{city_encoded}&count=1&language=pt&format=json"

  case HTTPoison.get(url) do
    {:ok, %{status_code: 200, body: body}} ->

      data =
        Jason.decode!(body)

      case data do
        %{"results" => [location | _]} ->

          latitude =
            location["latitude"]

          longitude =
            location["longitude"]

          country =
            location["country"]

          "🌎 #{city} fica em #{country}. Coordenadas: #{latitude}, #{longitude}"

        _ ->
          "Cidade não encontrada."
      end

    _ ->
      "Erro ao buscar curiosidade."
  end
end
end