module Coach4rb

  module Resource

    class Entry < Entity

      attr_accessor :id, :uri, :datecreated, :datemodified,
                    :entrydate, :comment, :entryduration,
                    :subscription, :entrylocation

      alias_method :created, :datecreated
      alias_method :modified, :datemodified

      alias_method :entry_date, :entrydate
      alias_method :entry_location, :entrylocation
      alias_method :entry_duration, :entryduration


      def self.from_coach(a_hash)
        entry_type = get_type(a_hash)
        raise 'Error: Entry type not supported!' unless CLASS.keys.include?(entry_type)

        entry = a_hash[entry_type].dup
        entry[:datecreated] = Time.at(entry[:datecreated]/1000).to_datetime if entry[:datecreated]
        entry[:datemodified] = Time.at(entry[:datemodified]/1000).to_datetime if entry[:datemodified]
        entry[:subscription] = Resource::Subscription.from_coach entry[:subscription] if entry[:subscription]
        entry[:links] ||= []

        klass = CLASS[entry_type] # pick the right class to create the entry
        klass.new(entry)
      end


      def type
        raise 'Not implemented!'
      end


      private

      def self.get_type(a_hash)
        a_hash.keys.first
      end

    end


    class Running < Entry

      include Mixin::TrackReader

      attr_accessor :coursetype, :courselength, :numberofrounds, :track

      alias_method :course_type, :coursetype
      alias_method :course_length, :courselength
      alias_method :number_of_rounds, :numberofrounds


      def type
        :running
      end

    end


    class Boxing < Entry

      attr_accessor :roundduration, :numberofrounds

      alias_method :round_duration, :roundduration
      alias_method :number_of_rounds, :numberofrounds



      def type
        :boxing
      end

    end


    class Soccer < Entry

      def type
        :soccer
      end

    end


    class Cycling < Entry

      include Mixin::TrackReader

      attr_accessor :coursetype, :courselength, :numberofrounds,
                    :bicycletype, :track

      alias_method :course_type, :coursetype
      alias_method :course_length, :courselength
      alias_method :number_of_rounds, :numberofrounds
      alias_method :bicycle_type, :bicycletype


      def type
        :cycling
      end

    end


    class Entry

      # lookup table which associates the types to the correct classes.
      CLASS = {
          # :type => Class
          :entryrunning => Running,
          :entrysoccer => Soccer,
          :entryboxing => Boxing,
          :entrycycling => Cycling
      }

    end


  end

end