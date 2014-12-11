module Coach4rb

  module Mixin


    module TrackReader

      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods

        def read_track
          Base64.decode64(track)
        end

      end

    end

  end

end