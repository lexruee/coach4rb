module Coach4rb

  module Resource

    class Entity

      include Mixin::AutoConstructor
      include Mixin::Iterable
      include Mixin::AsHash
      include Enumerable

      attr_accessor :uri, :links

      def self.from_coach(param)
        a_hash = param.dup
        a_hash[:links] ||= []
        self.new a_hash
      end


      def each(&block)
        instance_variables.each do |variable|
          value = instance_variable_get(variable)
          block.call variable, value
        end
      end


      def [](key)
        case key
          when Symbol
            super(key)
          else
            raise 'Error: param not supported!'
        end
      end


      def entity_path
        raise 'Not implemented!'
      end

    end

  end

end