#Coach4rb

![alt tag](https://raw.github.com/lexruee/coach4rb/master/coach4rb.png)


Coach4rb is a quick and dirty client solution for the Cyber Coach Webservice @unifr.ch.

For more details [see](https://diuf.unifr.ch/drupal/softeng/teaching/studentprojects/cyber-coach-rest).

Principles:

- This client mainly focuses on verbs (create/delete/update etc.) and tries to avoid the bad nouns.
- Another principle is that each returned object can be used again as input for another request and that all resources
are retrievable / updatable / deletable by their corresponding cyber coach uri.
- A retrieved coach user object can be reused for retrieving its subscriptions etc. 
- A coach client can be encapsulated behind a proxy object to provide access on protected resources in the scope of
a user.

##Some examples
Example: Creating a coach client
```ruby
 @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources'
    )

```

Example: Retrieving a user
```ruby
@coach_user = @coach.user_by_uri '/CyberCoachServer/resources/users/arueedlinger' # get a user by its uri
@coach_user = @coach.user 'arueedlinger' # get a user
```

Example: Encapsulating a coach client behind a proxy

```ruby
@proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'muha', @coach #@coach is our coach client
@proxy.users # get five users
@proxy.users query: { start: 0, size: 10 } #get ten users
```

Example: Updating a user
```ruby
@uri = '/CyberCoachServer/resources/users/arueedlinger'
@proxy.update_user(@uri) do |user|
      user.real_name = 'Alex Rueedlinger'
end

@user = @coach.user 'arueedlinger' # get a user
@proxy.update_user(@user) do |user|
      user.real_name = 'Alex Rueedlinger'
end

```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coach4rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coach4rb

## Usage

For testing the examples on this page open a terminal and run the ruby shell:
```
irb
```

Now, require the gem 'coach4rb'

```ruby
require 'coach4rb'
```

## Documentation

- [Rubygem website](https://rubygems.org/gems/coach4rb)
- [Documentation](http://lexruee.github.io/coach4rb/doc/)
- [Tests](https://github.com/lexruee/coach4rb/tree/master/test)

For a better understanding how the client works see the code examples in the file: [lib/coach4rb/coach.rb](https://github.com/lexruee/coach4rb/blob/master/lib/coach4rb/coach.rb)
and have a look at the [tests](https://github.com/lexruee/coach4rb/blob/master/test) with prefix ```test_coach_X```.
###Configuration
Coach4rb can be easily configured as the following example shows:


```ruby
 @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources'
    )

```

By setting the debug option to false all coach4rb exceptions are catched. By setting the debug option to true
all exceptions are 'ducked' to the caller.


```ruby
 @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources',
        debug: true
    )

```


To be sure that Coach4rb is correctly configured the method ```available?``` can be executed for testing purposes.

```ruby
@coach.available? # => true | false
```

###Resources
There are five different resources:

- Users

- Partnerships

- Subscriptions

- Entries

- Sports


####User
#####Authenticating a user

A user can be authenticated by the ```authenticate``` method. It returns on success a user object otherwise it returns
false.
```ruby
 @coach_user = @coach.authenticate('arueedlinger','muha')

if @coach_user
    puts @coach_user.username #=> 'arueedliger'
else
    raise 'Error'
end

```

#####Username availability
Use the method ```username_available?``` to check if a username is available:
```ruby
@coach.username_available? 'arueedlinger'
```


#####Retrieving a user / users
A user can be retrieved by means of the ```user``` method:

```ruby
users = @coach.user 'mojo'
```

A list of users can be obtained using the ```users``` method.
```ruby
users = @coach.users # get five users
```

For retrieving users in different ranges we can use the query option:
```ruby
users = @coach.users query: {start: 0, size: 10}
users.available # available users
users.size #10
users.end # 10
users.start # 0

next_users = @coach.users query: {start: 10, size: 10 }
 
```

#####Creating a user
A user can be created by means of the ```create_user``` instance method.

```ruby
@coach_user = @coach.create_user do |user|
    user.real_name = 'thehoff'
    user.username = 'therealhoff'
    user.public_visible = Coach4rb::Privacy::Public
    user.email = 'thehoff@ishereat.ch
end
```

If the request was successful it returns a Coach user object. Per default the property public_visible is always set to
```Coach4rb::Privacy::Public```. Other options are:

- Coach4rb::Privacy::Private
- Coach4rb::Privacy::Member

####Updating a user
In order to update an existing user we need an access proxy. Such an access proxy encapsulates a coach client
and provides access to resources in the scope of a given user. In other words the access proxy contains the necessary
user credentials that are needed to modify protected resources.

Such an access proxy object can be created as follows:
```
#@coach is our coach client, see configuration.
@proxy = Coach4rb::Proxy::Access.new @coach.username, 'secret', @coach

```

Updating a user can be done as follows. First we get a user, create a proxy object and pass to the proxy object our
coach client. After that we call the update_user method on the proxy object.

```ruby
@coach_user = @coach.user 'arueedlimger'
@proxy = Coach4rb::Proxy::Access.new @coach.username, 'secret', @coach
@proxy.update_user(@coach_user) do |user|
    user.email = 'muhaa@test.com'
    user.real_name = 'muhaha'
end

```

Another way to update a user is to pass a a cyber coach uri to the update_user method:
```ruby
@uri = '/CyberCoachServer/resources/users/arueedlinger'
@proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'secret', @coach
@proxy.update_user(@uri) do |user|
    user.email = 'muhaa@test.com'
    user.real_name = 'muhaha'
end

```

####Deleting a user
In the same way a user can be deleted.

```ruby
@proxy.delete_user(@coach_user)

```

####Subscriptions
A list of subscriptions are given in the property ```subscriptions``` of coach user object.

```ruby
@user = @coach.user 'arueedlinger'
subscriptions = @user.subscriptions
subscriptions.each do |s|
    @coach.subscription(s) # get details of a subscription
end
```

###Subscriptions
####Retrieving a subscription
If we have a user object or a partnership object we can retrieve all subscriptions as follows:
```ruby
@user = @coach.user 'arueedlinger'
subscriptions = @user.subscriptions
subscriptions.each do |s|
    @coach.subscription(s) # get details of a subscription
end
```


####Subscribe
User can subscribe to sport categories.
For that we can use the subscribe method.

```ruby

@proxy.subscribe(@coach_user,:running)
@proxy.subscribe(@coach_user,:soccer)
@proxy.subscribe(@coach_user,:cycling)
@proxy.subscribe(@coach_user,:boxing)
```

####Unsubscribe
A subscription can be removed using the unsubscribe method:
```
@proxy.unsubscribe(@coach_user,:boxing)
```

###Partnerships
Of course people like to be friends with each other. This is also the case in the cyber coach world.


####Retrieving partnerships
If we have a user object we can retrieve all partnerships as follows:
```ruby
@user = @coach.user 'arueedlinger', query: { start: 0, size: 10}
partnerships = @user.partnerships
partnerships.each do |p|
    @coach.partnership() # get details of a partnership
end
```

####Creating a partnership
Assume we have two persons Q and P.

```ruby
@p = @coach.username 'p'
@q = @coach.username 'q'
@proxy_for_p = Coach4rb::Proxy::Access.new @p.username, 'secret', @coach
@proxy_for_p.create_partnership(@p,@q) # public per default
@proxy_for_p.create_partnership(@p,@q) do |p|
    p.public_visible = Coach4rb::Privacy::Private
end
```

####Deleting a partnership
So if you like to end the partnership between q and p just use the breakup_between method. It sounds bad but
the operation is quickly executed:

```ruby
@proxy_for_p.breakup_between(@q,@p)

```

But if you prefer to remove the partnership directly you can use the ```delete_partnership``` method:

```ruby
a_partnership = @coach_user.partnerships.first

@proxy_for_p.delete_partnership(a_partnership)

```


###Entries
####Retrieving entries
If we have a user object or a partnership object we can retrieve a subset of all entries as follows:
```ruby
@user = @coach.user 'arueedlinger'
subscriptions = @user.subscriptions
subscriptions.each do |s|
    subscription = @coach.subscription s, query: {start: 0, size: 10 } # get details of a subscription
    subscription.entries do |e|
        entry = @coach.entry(e) # get details of an entry
    end
end
```


####Creating an entry for a user
Entries are created by means of the ```create_entry``` method.
```ruby
 @proxy.create_entry(@user, :running) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end

```
Depending on the entry different properties can be set. 
The next chapters provide an overview of all available properties tha can be set (set) and retrived (get).


####Creating an entry for a partnership

```ruby
 @partnership = @coach.partnership('arueedlinger','moritz')
 @proxy.create_entry(@partnership, :running) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end

```

###Updating an entry
Updating entry for a user or partnerships works excatly the same. You need to provide the create_entry method
a valid resource object like a user or a partnership object.
```ruby
 @user = @coach.user_by_uri '/CyberCoachServer/resources/users/wantsomemoney/'
 @entry = @coach.entry_by_uri '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
 @proxy = Coach4rb::Proxy::Access.new @user.username, 'secret', @coach
 @proxy.update_entry(@entry) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end

```


#####Running
Properties:

- id [get]
- created [get]
- modified [get]
- entry_location [set/get]
- entry_date [set/get]
- entry_duration [set/get]
- comment [set/get]
- public_visible [set/get]
- course_type [set/get]
- course_length [set/get]
- number_of_rounds [set/get]
- track [set/get]

#####Cycling
Properties:

- id [get]
- created [get]
- modified [get]
- entry_location [set/get]
- entry_date [set/get]
- entry_duration [set/get]
- comment [set/get]
- public_visible [set/get]
- course_type [set/get]
- course_length [set/get]
- number_of_rounds [set/get]
- bicycle_type [set/get]
- track [set/get]

#####Boxing
Properties:

- id [get]
- created [get]
- modified [get]
- entry_location [set/get]
- entry_date [set/get]
- entry_duration [set/get]
- comment [set/get]
- public_visible [set/get]
- round_duration [set/get]
- number_of_rounds [set/get]

#####Soccer
Properties:

- id [get]
- created [get]
- modified [get]
- entry_location [set/get]
- entry_date [set/get]
- entry_duration [set/get]
- comment [set/get]
- public_visible [set/get]



## Contributing

1. Fork it ( https://github.com/[my-github-username]/coach4rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Logo
Original Icon made by:

<a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a>
