module Coach4rb

  module Mixin

    module TrackWriter

      def track=(param)
        struct.track = Base64.encode64(param)
      end

      def track
        Base64.decode64(struct.track)
      end

    end

  end

end