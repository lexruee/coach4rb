module Coach4rb

  module Resource

    class Partnership < Entity

      attr_accessor :uri, :id, :userconfirmed1, :userconfirmed2,
                    :datecreated, :publicvisible, :user1, :user2,
                    :links, :subscriptions

      alias_method :created, :datecreated
      alias_method :visible, :publicvisible
      alias_method :first_user, :user1
      alias_method :second_user, :user2
      alias_method :first_user_confirmed, :userconfirmed1
      alias_method :second_user_confirmed, :userconfirmed2

      def self.from_coach(a_hash)
        new_hash = a_hash.dup
        new_hash[:datecreated] = Time.at(new_hash[:datecreated]/1000).to_datetime rescue nil
        new_hash[:subscriptions] ||= []
        new_hash[:subscriptions] = new_hash[:subscriptions].map {|a_hash| Resource::Subscription.from_coach a_hash }
        new_hash[:user1] = Resource::User.from_coach(new_hash[:user1]) rescue nil
        new_hash[:user2] = Resource::User.from_coach(new_hash[:user2]) rescue nil
        super new_hash
      end


      def entity_path
        "/partnerships/#{first_user.username};#{second_user.username}"
      end

    end

  end

end