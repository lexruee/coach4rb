module Coach4rb

  module Resource

    class Subscription < Entity
      attr_accessor :id, :uri, :datesubscribed, :publicvisble,
                    :partnership, :sport, :entries

      alias_method :created, :datesubscribed
      alias_method :visible, :publicvisble


      def self.from_coach(a_hash)
        new_hash = a_hash.dup
        new_hash[:datesubscribed] = Time.at(a_hash[:datesubscribed]/1000).to_datetime rescue nil
        new_hash[:partnership] =  Resource::Partnership.from_coach(new_hash[:partnership]) rescue nil
        new_hash[:user] =  Resource::User.from_coach(new_hash[:user]) rescue nil
        new_hash[:entries] =  new_hash[:entries].map {|a_hash| Resource::Entry.from_coach a_hash} rescue []
        new_hash[:sport] = Resource::Sport.from_coach(new_hash[:sport]) rescue nil
        super new_hash
      end


      def sport?(sport)
        raise 'Error: Invalid sport param!' if sport.nil?
        *, subscription_sport = uri.split('/') # get last part of the uri
        subscription_sport = subscription_sport.downcase.to_sym
        sport = sport.to_s.downcase.to_sym
        sport == subscription_sport
      end


      def entity_path
        if @user
          "/users/#{@user.username}/#{@sport}"
        elsif @partnership
          "/partnerships/#{@partnership.first_user.username};#{@partnership.second_user.username}/#{@sport}"
        else
          raise 'Error: cannot create url!'
        end
      end

    end

  end

end