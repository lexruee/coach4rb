module Coach4rb

  module Resource

    class Sport < Entity

      attr_accessor :id, :name, :description


      def self.from_coach(a_hash)
        new_hash = a_hash.dup
        self.new(new_hash)
      end

    end

  end

end