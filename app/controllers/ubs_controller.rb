class UbsController < ActionController::API
  def index
    offset = 0
    data = []
    limit = 1000

    while true
      url = "https://apidadosabertos.saude.gov.br/assistencia-a-saude/unidade-basicas-de-saude?limit=#{limit}&offset=#{offset}"
      response = Faraday.get(url)

      # Verifica se a resposta foi OK para evitar erros
      unless response.success?
        render status: response.status, json: { error: "Falha ao acessar API externa" }
        return
      end

      parsed_body = JSON.parse(response.body)
      ubs_data = parsed_body['ubs']

      break if ubs_data.nil? || ubs_data.empty?
      data.concat(ubs_data)
      puts "Requisição offset=#{offset}"

      offset += limit
    end

    filtred_data = data.map do |ubs|
      {
        nome: ubs['nome'],
        uf: ubs['uf'],
        cnes: ubs['cnes']
      }
    end

    render status: 200, json: filtred_data
  end
end
