module Coach4rb

  class JsonResponseParser < ResponseParser

    def parse(response)
      JSON.parse response, symbolize_names: true
    end

  end

end