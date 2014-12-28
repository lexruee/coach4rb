module Coach4rb

  module Mixin

    # This module provides an auto constructor and automatically provides
    # setters and getters for instance variables.
    #
    # The instance variables are created by the given hash
    # which is passed to the constructor.
    #
    # The keys in the hash are used as instance variable names and the corresponding
    # values are used to initialize the instance variable values.
    #
    # ==== Examples
    #
    #   class Test
    #       include Mixin::AutoConstructor
    #   end
    #
    #   test = Test.new { name: 'alex' }
    #   test.name # => 'alex'
    #
    module AutoConstructor

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods

        # Creates a object using the keys and values given in the hash.
        #
        # == Parameters:
        # @param a_hash [Hash] declaring the instance variables. The keys define the variable names
        #   and the corresponding values the initial values.
        #
        # @return [Object] the object specified by the given hash.
        def initialize(a_hash={})
          raise 'Param a_hash is not a hash!' unless a_hash.is_a? Hash
          a_hash.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        end


        # Provides hash-like access on the properties of this object.
        # @param key [Symbol] used to access the corresponding property.
        #
        def [](key)
          if value = instance_variable_get("@#{key}")
            value
          else
            send key rescue nil
          end
        end


        # Provides hash-like access on the properties of this object.
        # @param key [Symbol] used to access the corresponding property.
        #
        def []=(key,value)
          instance_variable_set("@#{key}",value)
        end

      end

    end

  end

end
