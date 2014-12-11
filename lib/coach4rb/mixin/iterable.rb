module Coach4rb

  module Mixin

    module Iterable

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods

        def has_next?
          link = self.next
          link ? link[:href] : false
        end


        def next
          links.detect { |link| link[:description] == 'next'}
        end


        def has_previous?
          link = previous
          link ? link[:href] : false
        end


        def previous
          links.detect { |link| link[:description] == 'previous'}
        end

      end

    end

  end

end