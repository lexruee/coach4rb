require 'rest_client'
require 'json'
require 'addressable/uri'
require 'gyoku'
require 'base64'
require 'ostruct'

require 'coach4rb/mixin/auto_constructor'
require 'coach4rb/mixin/as_hash'
require 'coach4rb/mixin/iterable'
require 'coach4rb/mixin/basic_auth'
require 'coach4rb/mixin/track_reader'
require 'coach4rb/mixin/track_writer'

require 'coach4rb/privacy'
require 'coach4rb/resource/entity'
require 'coach4rb/resource/page'
require 'coach4rb/resource/user'
require 'coach4rb/resource/sport'
require 'coach4rb/resource/entry'
require 'coach4rb/resource/partnership'
require 'coach4rb/resource/subscription'


require 'coach4rb/builder'
require 'coach4rb/proxy'
require 'coach4rb/response_parser'
require 'coach4rb/json_response_parser'
require 'coach4rb/coach'
require 'coach4rb/client'
require 'coach4rb/version'


module Coach4rb

  # Creates a Coach4rb client given the configuration hash config.
  #
  # @param [Hash] config
  # @return [Coach]
  #
  # ====Example
  # @example
  #   @client = Coach4rb::Client.new(
  #       scheme: 'http',
  #       host:  'diufvm31.unifr.ch',
  #       port:  8090,
  #       path:  '/CyberCoachServer/resources'
  #   )
  #
  def self.configure(config)
    client = Client.new(
        scheme: config[:scheme],
        host: config[:host],
        port: config[:port],
        path: config[:path]
    )

    config[:debug] ||= false

    response_parser = JsonResponseParser.new
    Coach.new(client, response_parser, config[:debug])
  end

end
