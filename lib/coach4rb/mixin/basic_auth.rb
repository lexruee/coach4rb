module Coach4rb

  module Mixin

    module BasicAuth

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods

        def basic_auth_encryption(username, password)
          'Basic ' + Base64.encode64("#{username}:#{password}").chomp
        end

      end

    end

  end

end