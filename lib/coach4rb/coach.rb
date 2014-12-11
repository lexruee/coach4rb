module Coach4rb

  class Coach
    include Mixin::BasicAuth

    # Creates a Coach client for the cyber coach webservcie.
    #
    # @param [Client] client
    # @param [ResponseParser] response_parser
    # @param [Boolean] debug
    # @return [Coach]
    #
    def initialize(client, response_parser, debug)
      @client = client
      @response_parser = response_parser
      @debug = debug
    end


    # Authenticates a user against the Cyber Coach Webservice.
    #
    # @param username
    # @param password
    # @return [User]
    #
    # ====Example
    #
    # @coach.authenticate('arueedlinger', 'test')
    #
    def authenticate(username, password)
      begin
        options = {authorization: basic_auth_encryption(username, password)}
        url = url_for_path('/authenticateduser/')
        client.get(url, options) do |response|
          if response.code == 200
            a_hash = parse response
            Resource::User.from_coach a_hash
          else
            false
          end
        end
      rescue
        raise 'Error: Could not authenticate user!'
      end
    end


    # Tests if the given username is available.
    #
    # @param username
    # @return [Boolean]
    #
    # ====Example
    #
    # @coach.username_available('arueedlinger')
    #
    def username_available?(username)
      # check if username is alphanumeric and that it contains at least one letter
      return false unless /^[a-zA-Z0-9]{1,}$/ =~ username
      !user_exists?(username) rescue raise 'Error: Could not test username availability!'
    end


    # Tests if the user given its username exists..
    #
    # @param username
    # @return [Boolean]
    #
    # ====Example
    #
    # @coach.user_exsists?('arueedlinger')
    #
    def user_exists?(username)
      begin
        url = url_for_path(user_path(username))
        client.get(url) { |response| response.code == 200 }
      rescue
        raise 'Error: Could not test user existence!'
      end
    end


    # Checks if the Cyber Coach Webservice is available.
    #
    # @return [Boolean]
    #
    # ====Example
    #
    # @coach.available?
    #
    def available?
      client.get(url_for_path('/')) { |response| response.code == 200 } rescue false
    end


    # Creates a user with public visibility as default.
    #
    # @param [Hash] options
    # @param [Block] block
    # @return [User]
    #
    # ====Examples
    #
    # @coach.create_user do |user|
    #   user.real_name= 'the hoff'
    #   user.username= 'wantsomemoney'
    #   user.password= 'test'
    #   user.email= 'test@test.com'
    #   user.public_visible= 2
    # end
    #
    def create_user(options={}, &block)
      builder = Builder::User.new(public_visible: Privacy::Public)
      block.call(builder)
      url = url_for_path(user_path(builder.username))

      begin
        client.put(url, builder.to_xml, options) do |response|
          a_hash = parse response
          Resource::User.from_coach a_hash
        end
      rescue =>e
        raise e if debug
        false
      end
    end


    # Updates a user.
    #
    # @param [User|String] user
    # @param [Hash] options
    # @param [Block] block
    # @return [User]
    #
    # ====Examples
    #
    # @coach.update_user(user) do |user
    #   user.real_name= 'the hoff'
    #   user.password= 'test'
    #   user.email= 'test@test.com'
    #   user.public_visible= 2
    # end
    #
    def update_user(user, options={}, &block)
      raise 'Error: Param user is nil!' if user.nil?

      builder = Builder::User.new
      block.call(builder)
      url = if user.is_a?(Resource::User) && user.uri
              url_for_resource(user)
            else
              url_for_uri(user)
            end

      begin
        client.put(url, builder.to_xml, options) do |response|
          a_hash = parse response
          Resource::User.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Deletes a user.
    #
    # @param [User\String] user
    # @param [Hash] options
    # @return [Boolean]
    #
    # ====Examples
    #
    # @coach.delete_user(user)
    # @coach.delete_user('arueedlinger')
    #
    def delete_user(user, options={})
      raise 'Error: Param user is nil!' if user.nil?

      url = if user.is_a?(Resource::User)
        url_for_resource(user)
      elsif user.is_a?(String)
        url_for_path(user_path(user))
      else
        raise 'Error: Invalid parameters!'
      end
      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
      end
    end


    # Creates a partnership with public visibility as default.
    #
    # @param [User|String] first_user
    # @param [User|String] second_user
    # @param [Hash] options
    # @return [Partnership]
    #
    # ====Examples
    #
    # @coach.create_partnership('arueedlinger','wanze2')
    #
    # @coach.create_partnership('arueedlinger','wanze2') do |p|
    #    p.public_visible = Coach4rb::Private
    # end
    #
    def create_partnership(first_user, second_user, options={}, &block)
      raise 'Error: Param first_user is nil!' if first_user.nil?
      raise 'Error: Param second_user is nil!' if second_user.nil?

      path = if first_user.is_a?(Resource::User) && second_user.is_a?(Resource::User)
               partnership_path(first_user.username, second_user.username)
             elsif first_user.is_a?(String) && second_user.is_a?(String)
               partnership_path(first_user, second_user)
             else
               raise 'Error: Invalid parameters!'
             end
      url = url_for_path(path)
      builder = Builder::Partnership.new(public_visible: Privacy::Public)
      block.call(builder) if block_given?
      begin
        client.put(url, builder.to_xml, options) do |response|
          a_hash = parse response
          Resource::Partnership.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Deletes a partnership
    #
    # @param [Partnership] partnership
    # @param [Hash] options
    # @return [Boolean]
    #
    def delete_partnership(partnership, options={})
      raise 'Error: Param partnership is nil!' if partnership.nil?

      url = url_for_resource(partnership)
      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Breaks up a partnership between two users.
    #
    # @param [User|String] first_user
    # @param [User|String] second_user
    # @param [Hash] options
    # @return [Boolean]
    #
    def breakup_between(first_user, second_user, options={})
      raise 'Error: Param first_user is nil!' if first_user.nil?
      raise 'Error: Param second_user is nil!' if second_user.nil?

      path = if first_user.is_a?(Resource::User) && second_user.is_a?(Resource::User)
               partnership_path(first_user.username, second_user.username)
             elsif first_user.is_a?(String) && second_user.is_a?(String)
               partnership_path(first_user, second_user)
             else
               raise 'Error: Invalid parameters!'
             end
      url = url_for_path(path)
      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Creates a subscription with public visibility as default.
    #
    # @param [User|Partnership|String] user_partnership
    # @param [String] sport
    # @param [Hash] options
    # @param [Block] block
    # @return [Subscription]
    #
    # ====Examples
    #
    # @coach.create_subscription(user, :boxing) do |subscription|
    #   subscription.public_visible = Coach4rb::Privacy::Public
    # end
    #
    # @coach.create_subscription(user, :boxing)
    #
    # partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    # @coach.subscribe(partnership, :running)
    #
    def create_subscription(user_partnership, sport, options={}, &block)
      raise 'Error: Param user_partnership is nil!' if user_partnership.nil?
      raise 'Error: Param sport is nil!' if sport.nil?

      url = if user_partnership.is_a?(Resource::User)
              url_for_path(subscription_user_path(user_partnership.username, sport))
            elsif user_partnership.is_a?(Resource::Partnership)
              first_username = user_partnership.first_user.username
              second_username = user_partnership.second_user.username
              url_for_path(subscription_partnership_path(first_username, second_username, sport))
            elsif user_partnership.is_a?(String)
              url_for_uri(user_partnership)
            else
              raise 'Error: Invalid parameter!'
            end

      builder = Builder::Subscription.new(public_visible: Privacy::Public)
      block.call(builder) if block_given?

      begin
        client.put(url, builder.to_xml, options) do |response|
          a_hash = parse response
          Resource::Subscription.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end

    alias_method :update_subscription, :create_subscription
    alias_method :subscribe, :create_subscription


    # Deletes a subscription.
    #
    # @param [Subscription|String] subscription
    # @param [Hash] options
    # @return [Boolean]
    #
    # ====Examples
    #
    # user = @coach.user 'arueedlinger'
    # @coach.unsubscribe(user, :boxing)
    #
    # partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    # @coach.unsubscribe(partnership, :running)
    #
    def unsubscribe(user_partnership, sport, options={})
      raise 'Error: Param user_partnership is nil!' if user_partnership.nil?
      raise 'Error: Param sport is nil!' if sport.nil?

      url = if user_partnership.is_a?(Resource::User)
              url_for_path(subscription_user_path(user_partnership.username, sport))
            elsif user_partnership.is_a?(Resource::Partnership)
              first_username = user_partnership.first_user.username
              second_username = user_partnership.second_user.username
              url_for_path(subscription_partnership_path(first_username, second_username, sport))
            elsif user_partnership.is_a?(String)
              url_for_uri(user_partnership)
            else
              raise 'Error: Invalid parameter!'
            end

      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
        false
      end
    end

    # Deletes a subscription.
    #
    # @param [Subscription] subscription
    # @param [Hash] options
    # @return [Boolean]
    #
    def delete_subscription(subscription, options={})
      raise 'Error: Param subscription is nil!' if subscription.nil?

      url = url_for_resource(subscription)
      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Creates an entry with public visibility as default.
    #
    # @param [User|Partnership|String] user_partnership
    # @param [Hash] options
    # @param [Block] block
    # @return [Entry|Boolean]
    #
    # ====Examples
    # entry = @coach.create_entry(@user, :running) do |e|
    #   e.comment = 'test'
    #   e.number_of_rounds = 10
    #   e.public_visible = Coach4rb::Privacy::Public
    # end
    #
    # entry = @coach.create_entry(@user, :soccer) do |e|
    #   e.comment = 'test'
    #   e.number_of_rounds = 10
    # end
    #
    def create_entry(user_partnership, sport, options={}, &block)
      raise 'Error: Param user_partnership is nil!' if user_partnership.nil?
      raise 'Error: Param sport is nil!' if sport.nil?

      entry_type = sport.downcase.to_sym
      builder = Builder::Entry.builder(entry_type)

      url = if user_partnership.is_a?(Resource::Entity)
              url_for_resource(user_partnership) + sport.to_s
            elsif user_partnership.is_a?(String)
              url_for_uri(user_partnership) + sport.to_s
            else
              raise 'Error: Invalid parameter!'
            end

      block.call(builder) if block_given?

      begin
        client.post(url, builder.to_xml, options) do |response|
          if uri = response.headers[:location]
            entry_by_uri(uri, options)
          else
            false
          end
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Updates an entry.
    #
    # @param [Entry|String] entry
    # @param [Hash] options
    # @param [Block] block
    # @return [Entry|Boolean]
    #
    # ====Examples
    #
    # entry = @coach.entry_by_uri '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
    # updated_entry = @proxy.update_entry(entry) do |entry|
    #   entry.comment = 'Test!!'
    # end
    #
    # uri = '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
    # res = @proxy.update_entry(uri) do |entry|
    #   entry.comment = 'Test!'
    # end
    #
    def update_entry(entry, options={}, &block)
      raise 'Error: Param entry is nil!' if entry.nil?

      url, entry_type = if entry.is_a?(Resource::Entry)
                          [url_for_resource(entry), entry.type]
                        else
                          *, type, id = url_for_uri(entry).split('/')
                          type = type.downcase.to_sym
                          [url_for_uri(entry), type]
                        end

      builder = Builder::Entry.builder(entry_type)
      block.call(builder)
      begin
        client.put(url, builder.to_xml, options) do |response|
          a_hash = parse(response)
          Resource::Entry.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Deletes an entry..
    #
    # @param [Entry|String] entry
    # @param [Hash] options
    # @return [Boolean]
    #
    def delete_entry(entry, options={})
      raise 'Error: Param entry is nil!' if entry.nil?

      url = if entry.is_a?(Resource::Entry)
              url_for_resource(entry)
            elsif entry.is_a?(String)
              url_for_uri(entry)
            else
              raise 'Error: Invalid parameter!'
            end
      begin
        client.delete(url, options) do |response|
          response.code == 200
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Retrieves a user by its username.
    #
    # @param [String|User] username | user
    # @param [Hash] options
    # @return [User]
    #
    # ====Examples
    #
    # user = @coach.user a_user
    # user = @coach.user 'arueedlinger'
    # user = @coach.user 'arueedlinger', {}
    #
    def user(user, options={})
      raise 'Error: Param user is nil!' if user.nil?

      url = if user.is_a?(Resource::User)
              url_for_resource(user)
            elsif user.is_a?(String)
              url_for_path(user_path(user))
            else
              raise 'Error: Invalid parameter!'
            end
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::User.from_coach a_hash
      end
    end


    # Retrieves a user by its uri.
    #
    # @param [String] uri
    # @param [Hash] options
    # @return [User]
    #
    # user = @coach.user_by_uri '/CyberCoachServer/resources/users/arueedlinger', {}
    # user = @coach.user_by_uri '/CyberCoachServer/resources/users/arueedlinger'
    #
    def user_by_uri(uri, options={})
      raise 'Error: Param uri is nil!' if uri.nil?

      url = url_for_uri(uri)
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::User.from_coach a_hash
      end
    end


    # Retrieves users.
    #
    # @param [Hash] options
    # @return [PageResource]
    #
    # ====Examples
    # users = @coach.users
    # users = @coach.users query: { start: 0, size: 10}
    #
    def users(options={query: {}})
      url = url_for_path(user_path)
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Page.from_coach a_hash, Resource::User
      end
    end


    # Retrieves a partnership by its uri.
    #
    # @param [String] uri
    # @param [Hash] options
    # @return [Partnership]
    #
    # ====Example
    #
    # partnership = @coach.partnership_by_uri '/CyberCoachServer/resources/partnerships/arueedlinger;asarteam5/'
    #
    def partnership_by_uri(uri, options={})
      raise 'Error: Param uri is nil!' if uri.nil?

      url = url_for_uri(uri)
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Partnership.from_coach a_hash
      end
    end


    # Retrieves a partnership by the first username and second username.
    #
    # @param [String] first_username
    # @param [String] second_username
    # @param [Hash] options
    # @return [Partnership]
    #
    # ====Example
    #
    # partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    #
    def partnership(first_username, second_username, options={})
      raise 'Error: Param first_username is nil!' if first_username.nil?
      raise 'Error: Param second_username is nil!' if second_username.nil?

      url = url_for_path(partnership_path(first_username, second_username))
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Partnership.from_coach a_hash
      end
    end


    # Retrieves partnerships.
    #
    # @param [Hash] options
    # @return [PageResource]
    #
    # ====Examples
    #
    # partnerships = @coach.partnerships
    # partnerships = @coach.partnerships query: { start: 0, size: 10}
    #
    def partnerships(options={query: {}})
      url = url_for_path(partnership_path)
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Page.from_coach a_hash, Resource::Partnership
      end
    end


    # Retrieves a subscription.
    #
    # ====Example
    #
    # subscription = @coach.subscription_by_uri '/CyberCoachServer/resources/users/newuser4/'
    #
    def subscription_by_uri(uri, options={})
      raise 'Error: Param uri is nil!' if uri.nil?

      url = url_for_uri(uri)
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Subscription.from_coach a_hash
      end
    end


    # Retrieves a subscription.
    #
    # @param [String|Subscription] first_user | subscription
    # @param [String] second_user | sport
    # @param [String|Hash] sport | options
    # @param [Hash|nil] options
    #
    # ====Examples
    #
    # subscription = @coach.subscription subscription
    # subscription = @coach.subscription subscription, {}
    # subscription = @coach.subscription 'newuser4', 'running'
    # subscription = @coach.subscription 'newuser4', 'running', {}
    # subscription = @coach.subscription 'newuser4','newuser5', 'running'
    # subscription = @coach.subscription 'newuser4','newuser5', 'running', {}
    # subscription = @coach.subscription 'newuser4', :running
    # subscription = @coach.subscription 'newuser4', :running, {}
    # subscription = @coach.subscription 'newuser4','newuser5', :running
    # subscription = @coach.subscription 'newuser4','newuser5', :running, {}
    #
    def subscription(*args)
      first_param, second_param, third_param, fourth_param, = args
      url, options = if first_param.is_a?(Resource::Entry) && first_param.uri
                       [url_for_resource(first_param), second_param || {}]
                     elsif first_param.is_a?(String) && second_param.is_a?(String) && (third_param.is_a?(String) || third_param.is_a?(Symbol))
                       [url_for_path(subscription_partnership_path(first_param, second_param, third_param)), fourth_param || {}]
                     elsif first_param.is_a?(String) && (second_param.is_a?(String) || second_param.is_a?(Symbol))
                       [url_for_path(subscription_user_path(first_param, second_param)), third_param || {}]
                     elsif first_param.is_a?(Resource::Subscription)
                       [url_for_resource(first_param), second_param || {}]
                     else
                       raise 'Error: Invalid parameters!'
                     end
      url = append_query_params(url, options)
      client.get(url, options) do |response|
        a_hash = parse(response)
        Resource::Subscription.from_coach a_hash
      end
    end


    # Retrieves an entry by its uri.
    #
    # ====Example
    #
    # entry = @coach.entry_by_uri '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
    #
    def entry_by_uri(uri, options={})
      raise 'Error: Param uri is nil!' if uri.nil?

      begin
        url = url_for_uri(uri)
        url = append_query_params(url, options)
        client.get(url, options) do |response|
          return false if response.code == 404
          a_hash = parse(response)
          Resource::Entry.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end


    # Retrieves an entry.
    #
    # ====Example
    #
    # subscription = @coach.subscription 'arueedlinger', 'running'
    # subscription_entry = subscription.entries.first
    # entry = @coach.entry subscription_entry
    #
    def entry(entry, options={})
      raise 'Error: Param entry is nil!' if entry.nil?

      begin
        url = url_for_resource(entry)
        url = append_query_params(url, options)
        client.get(url, options) do |response|
          a_hash = parse(response)
          Resource::Entry.from_coach a_hash
        end
      rescue => e
        raise e if debug
        false
      end
    end


    private

    def debug
      @debug
    end

    def client
      @client
    end

    def parse(response)
      @response_parser.parse(response)
    end

    # Url helpers and path helpers for creating correct urls.

    def url_for_resource(resource)
      if resource.uri
        "#{client.site}#{resource.uri}"
      else
        "#{client.service_uri}#{resource.entity_path}"
      end
    end


    def url_for_uri(uri)
      "#{client.site}#{uri}"
    end


    def url_for_path(path)
      "#{client.service_uri}#{path}"
    end


    def user_path(username='')
      "/users/#{username}"
    end


    def partnership_path(first_username=nil, second_username=nil)
      if first_username.nil? && second_username.nil?
        '/partnerships/'
      elsif first_username && second_username
        "/partnerships/#{first_username};#{second_username}"
      else
        raise 'Error: Invalid parameters!'
      end
    end


    def subscription_user_path(username, sport)
      "/users/#{username}/#{sport}"
    end


    def subscription_partnership_path(first_username, second_username, sport)
      "/partnerships/#{first_username};#{second_username}/#{sport}"
    end


    def append_query_params(url, options)
      new_uri = Addressable::URI.parse(url)
      new_uri.query_values = options[:query] if options[:query]
      options.delete(:query) #clean up
      new_uri.to_s
    end

  end

end