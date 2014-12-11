module Coach4rb

  module Resource

    class Page

      include Mixin::AutoConstructor
      include Mixin::Iterable
      include Mixin::AsHash
      include Enumerable

      attr_accessor :start, :end, :available, :links, :type, :uri

      def self.from_coach(a_hash, entity_class=Entity)
        new_hash = a_hash.dup
        type_plural = pluralize(new_hash[:type]) if new_hash[:type]
        type_plural ||= false
        new_hash[:links] ||= []
        new_hash[:type] = type_plural
        new_hash[:entity_class] ||= entity_class
        self.new new_hash
      end


      def entities
        if @type && @entities.nil?
          hashes = instance_variable_get("@#{@type}")
          @entities = hashes.map { |a_hash| @entity_class.from_coach a_hash }
        else
          @entities
        end
      end

      alias_method :items, :entities

      def size
        entities.size
      end


      def [](key)
        case key
          when Integer
            entities[key]
          when Symbol
            super(key)
          else
            raise 'Error: param not supported!'
        end
      end


      def each(&block)
        entities.each do |item|
          block.call item
        end
      end

      def to_a
        entities
      end

      private

      def self.pluralize(type)
        type[-1] == 's' ? type : type + 's' # pluralize
      end


    end

  end

end