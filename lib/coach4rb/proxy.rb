module Coach4rb

  # This module provides global access to the cyber coach resources in the scope
  # of the given user credentials.
  #
  module Proxy

    # This class provides an interface that all subclasses must implement.
    #
    class Base
      include Mixin::BasicAuth

      attr_reader :coach

      # Base access proxy which is extended by the subclasses to provide more specific access to the coach client.
      #
      # @param [Coach] coach
      #
      def initialize(coach)
        @coach = coach
      end


      def username
        raise 'Not implemented!'
      end


      def password
        raise 'Not implemented!'
      end

      # Always returns an empty hash.
      # @return [Hash]
      #
      def proxy_options
        {}
      end


      # Tests if the provided user credentials are valid.
      # @return [Boolean]
      #
      def valid?
        begin
          coach.authenticate(username, password)
        rescue
          false
        end
      end


      # Delegates all messages send to this proxy to the coach client
      #
      def method_missing(meth, *args, &block)
        params = *args

        # handle options hash
        if params.last.is_a?(Hash) # if last param is a hash then it's a option hash.
          params[-1] = params.last.merge(proxy_options)
        else # otherwise add a option hash with the given proxy options.
          params << proxy_options
        end

        # check if coach responds to the message meth / or method meth
        if coach.respond_to?(meth)
          begin # try to pass the options hash
            coach.send meth, *params, &block
          rescue # otherwise do it without options hash
            coach.send meth, *args, &block
          end
        else
          raise 'Error: Method missing in coach!'
        end
      end
    end


    # This class provides a general access proxy for the cyber coach service.
    # It is used to have global access to the cuber coach service in the perspective of a specific user.
    #
    class Access < Base

      attr_reader :username, :password

      # Creates an access proxy which provides global access to the cyber coach in the scope of the
      # given user credentials.
      #
      # @param [String] username
      # @param [String] password
      # @param [Coach] coach
      #
      # ====Examples
      # @example
      #   @proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'muha', @coach_client
      #
      def initialize(username, password, coach)
        @username = username
        @password = password
        @coach = coach
        @base64 = basic_auth_encryption(@username, @password)
      end


      # Returns an hash with basic auth http options.
      # @return [Hash]
      #
      def proxy_options
        {authorization: @base64}
      end

    end


    # This class provides an invalid access proxy which will always fail.
    #
    class InvalidAccess < Base

      # Returns always false.
      # @return [FalseClass]
      #
      def valid?
        false
      end


      # Returns always nil.
      # @return [NilClass]
      #
      def username
        nil
      end


      # Returns always nil.
      # @return [NilClass]
      #
      def password
        nil
      end

    end

  end


end