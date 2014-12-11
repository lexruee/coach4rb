module Coach4rb

  module Mixin

    module AsHash

      def self.included(base)
        base.send :include, InstanceMethods
      end


      module InstanceMethods

        # Converts this object to a hash.
        #
        def to_hash
          variables = instance_variables
          hash = {}
          variables.each do |name|
            key = name.to_s.sub(/^@/, '')
            hash[key.to_sym] = instance_variable_get(name)
          end
          hash
        end

        alias_method :to_h, :to_hash

      end

    end

  end

end