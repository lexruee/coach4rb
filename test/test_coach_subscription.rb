require 'test/test_helper'

class TestSubscriptionCoach < MiniTest::Test

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host:  'diufvm31.unifr.ch',
        port:  8090,
        path:  '/CyberCoachServer/resources',
        debug: true
    )
  end


  def test_should_subscribe_a_user_to_running
    proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach
    user = @coach.user 'wantsomemoney'

    subscription =  proxy.subscribe(user, 'running') do |subscription|
      subscription.public_visible = Coach4rb::Privacy::Public
    end
    assert subscription
  end

  def test_should_subscribe_partnership_to_running
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    assert proxy.subscribe(partnership, :running)
  end


  def test_should_subscribe_and_unsubscribe_a_user_to_boxing
    proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach
    user = @coach.user 'wantsomemoney'

    subscription =  proxy.subscribe(user, :boxing) do |subscription|
      subscription.public_visible = Coach4rb::Privacy::Public
    end
    assert subscription

    sleep 2
    assert proxy.unsubscribe(user, :boxing)
  end


  def test_should_subscribe_and_unsubscribe_a_partnership_to_boxing
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    assert proxy.subscribe(partnership, :running)

    subscription =  proxy.subscribe(partnership, :boxing)
    assert subscription
    sleep 20
    assert proxy.unsubscribe(partnership, :boxing)
  end



  def test_should_subscribe_and_unsubscribe_a_user_to_soccer
    proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach
    user = @coach.user 'wantsomemoney'

    assert proxy.subscribe(user, :soccer)
    sleep 2
    assert proxy.unsubscribe(user, :soccer)
  end


  def test_should_subscribe_and_unsubscribe_a_user_to_cycling
    proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach
    user = @coach.user 'wantsomemoney'

    subscription = proxy.subscribe(user, :cycling)
    sleep 2
    assert subscription
    assert proxy.delete_subscription(subscription)
  end


  def test_should_get_subscription
    subscription = @coach.subscription 'newuser4', 'running', {}
    assert subscription
    #subscription = @coach.subscription 'newuser4','newuser5', 'running', {}
    assert subscription
    subscription = @coach.subscription 'newuser4', 'running'
    assert subscription
    #subscription = @coach.subscription 'newuser4','newuser5', 'running'
    subscription = @coach.subscription_by_uri '/CyberCoachServer/resources/users/newuser4/'
    assert subscription
    subscription = @coach.subscription subscription
    assert subscription
  end


  def test_should_get_subscription_entries
    subscription = @coach.subscription 'arueedlinger', 'running', query: {start: 1, size: 10}
    assert subscription
    assert_equal 10, subscription.entries.size
  end


  def test_should_get_entry_from_subscription
    subscription = @coach.subscription 'arueedlinger', 'running', query: {start: 0, size: 10}
    subscription.entries.each do |entry|
      assert @coach.entry(entry)
    end
  end

end