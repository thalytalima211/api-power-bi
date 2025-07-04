class PokemonsController < ActionController::API
  def index
    url = "https://pokeapi.co/api/v2/pokemon?limit=100"
    data = []

    while url
      response = Faraday.get(url)

      # Verifica se a resposta foi OK para evitar erros
      unless response.success?
        render status: response.status, json: { error: "Falha ao acessar API externa" }
        return
      end

      parsed_body = JSON.parse(response.body)
      data.concat(parsed_body['results'] || [])

      url = parsed_body['next']
    end

    render status: 200, json: data
  end
end
