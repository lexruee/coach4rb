module Coach4rb

  # This class provides a simple http client.
  #
  #
  class Client

    def initialize(a_hash)
      @service_uri = Addressable::URI.new a_hash
      @basic_options = {
          accept: :json,
          content_type: :xml
      }
    end


    def service_uri
      @service_uri
    end


    def path
      @service_uri.path
    end


    def site
      @service_uri.site
    end


    def port
      @service_uri.port
    end


    def host
      @service_uri.host
    end


    def scheme
      @service_uri.scheme
    end


    # Performs a get request.
    #
    # @param [String] url
    # @param [Hash] options
    # @param [Block] block
    # @return [String] the payload of the response as string
    def get(url, options={}, &block)
      http_options = options.merge(@basic_options)
      if block_given?
        RestClient.get(url, http_options, &block)
      else
        RestClient.get(url, http_options)
      end
    end


    # Performs a put request.
    #
    # @param [String] url
    # @param [String] payload
    # @param [Block] block
    # @return [String] the payload of the response as string
    #
    def put(url, payload, options={}, &block)
      http_options = options.merge(@basic_options)
      if block_given?
        RestClient.put(url, payload, http_options, &block)
      else
        RestClient.put(url, payload, http_options)
      end

    end


    # Performs a post request.
    #
    # @param [String] url
    # @param [String] payload
    # @param [Block] block
    # @return [String] the payload of the response as string
    #
    def post(url, payload, options={}, &block)
      http_options = options.merge(@basic_options)
      if block_given?
        RestClient.post(url, payload, http_options, &block)
      else
        RestClient.post(url, payload, http_options)
      end
    end


    # Performs a delete request.
    #
    # @param [String] url
    # @param [Hash] options
    # @param [Block] block
    # @return [String] the payload of the response as string
    #
    def delete(url, options={}, &block)
      http_options = options.merge(@basic_options)
      if block_given?
        RestClient.delete(url, http_options, &block)
      else
        RestClient.delete(url, http_options)
      end
    end

  end

end