module Coach4rb

  module Resource

    class User < Entity

      attr_accessor :username, :password, :email, :realname,
                    :datecreated, :publicvisible, :partnerships,
                    :subscriptions

      alias_method :real_name, :realname
      alias_method :created, :datecreated
      alias_method :public_visible, :publicvisible


      def self.from_coach(a_hash)
        new_hash = a_hash.dup
        new_hash[:password] = nil # avoid having a star password
        new_hash[:partnerships] ||= []
        new_hash[:partnerships] = new_hash[:partnerships].map {|a_hash| Resource::Partnership.from_coach a_hash }
        new_hash[:subscriptions] ||= []
        new_hash[:subscriptions] = new_hash[:subscriptions].map {|a_hash| Resource::Subscription.from_coach a_hash }
        new_hash[:datecreated] = Time.at(new_hash[:datecreated]/1000).to_datetime rescue nil
        super(new_hash)
      end


      def entity_path
        "/users/#{username}"
      end


      private

      def to_flat_hash
        a_hash = {
            username: username,
            password: password,
            email: email,
            publicvisible: public_visible,
            realname: real_name
        }
      end

    end

  end

end