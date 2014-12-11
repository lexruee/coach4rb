module Coach4rb

  module Builder

    class Base

      def initialize(a_hash={})
        @struct = OpenStruct.new(a_hash)
      end

      def to_xml
        a_hash = to_adjusted_hash
        Gyoku.xml(type => a_hash)
      end


      def method_missing(meth,*args,&block)
        struct.send meth, *args, &block
      end


      def type
        raise 'Error'
      end


      private

      def struct
        @struct
      end


      def to_adjusted_hash
        properties = struct.to_h
        new_hash = {}
        properties.each do |key, value|
          string_key = key.to_s
          string_key = string_key.gsub('_', '')
          new_hash[string_key.to_sym] = value
        end
        new_hash
      end

    end


    class Partnership < Base

      def type
        :partnership
      end

    end


    class Subscription < Base

      def type
        :subscription
      end

    end


    class User < Base

      def type
        :user
      end

    end


    class Entry < Base


    end


    class Running < Entry

      include Mixin::TrackWriter

      def type
        :entryrunning
      end

    end


    class Cycling < Entry

      include Mixin::TrackWriter

      def type
        :entrycycling
      end

    end


    class Boxing < Entry

      def type
        :entryboxing
      end

    end


    class Soccer < Entry

      def type
        :entrysoccer
      end

    end

    class Entry

      def self.builder(type)
        klass = case type
                  when :running
                    Running
                  when :cycling
                    Cycling
                  when :boxing
                    Boxing
                  when :soccer
                    Soccer
                  else
                    raise 'Error: %s is not supported!' % type
                end
        klass.new(public_visible: Privacy::Public)
      end

    end

  end

end