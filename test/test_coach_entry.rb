require 'test/test_helper'

class TestCoachEntry < MiniTest::Test

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources',
        debug: true
    )
    @proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach
    @user = @coach.user 'wantsomemoney'
    assert @proxy.valid?
  end


  def test_should_get_entry_by_its_uri
    uri = '/CyberCoachServer/resources/users/wantsomemoney/Running/1132/'
    entry = @coach.entry_by_uri uri
    assert entry
  end


  def test_should_get_entry
    entry = @coach.entry_by_uri '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
    entry = @coach.entry entry
    assert entry
  end


  def test_should_get_an_entry_of_a_partnership
    partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    assert partnership.subscriptions.size > 0
    running = partnership.subscriptions.detect { |s| s.sport? :running }
    assert running
    subscription = @coach.subscription running
    assert subscription
    subscription.entries.each do |entry|
      assert @coach.entry entry
    end

  end


  def test_should_get_an_entry_of_a_user
    user = @coach.user 'arueedlinger'
    assert user.subscriptions.size > 0
    running = user.subscriptions.detect { |s| s.sport? :running }
    assert running
    subscription = @coach.subscription running
    assert subscription
    subscription.entries.each do |entry|
      assert @coach.entry entry
    end

  end


  def test_should_create_an_entry_for_a_user
    res = @proxy.create_entry(@user, :running) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end
    assert res
    assert res.uri
  end


  def test_should_create_an_entry_using_a_uri
    res = @proxy.create_entry(@user.uri, :running) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end
    assert res
    assert res.uri
  end


  def test_should_create_an_entry_for_a_partnership
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    partnership = @coach.partnership 'arueedlinger', 'asarteam5'
    res = proxy.create_entry(partnership, :running) do |entry|
      entry.comment = 'test'
      entry.number_of_rounds = 10
      entry.public_visible = Coach4rb::Privacy::Public
    end
    assert res
    assert res.uri
  end



  def test_should_update_an_entry_using_a_uri
    uri = '/CyberCoachServer/resources/users/wantsomemoney/Running/1138/'
    res = @proxy.update_entry(uri) do |entry|
      entry.comment = 'Test!!'
      entry.entry_location = 'sajfsjdjasd'
      entry.number_of_rounbds = 10000
      entry.entry_date = DateTime.now
      entry.track = 'jhasjdhjashjkdasjdjkasndj'
    end
    assert res
    assert res.uri
  end


  def test_should_update_an_entry
    entry = @proxy.entry_by_uri '/CyberCoachServer/resources/users/wantsomemoney/Running/1139/'
    updated_entry = @proxy.update_entry(entry) do |entry|
      entry.comment = 'Test!!'
      entry.track = 'muhaa!!!!'
    end
    assert updated_entry
    assert updated_entry.uri
    assert_equal 'Test!!', updated_entry.comment
    pp updated_entry.read_track
    assert_equal 'muhaa!!!!', updated_entry.read_track
  end


  def test_should_create_and_delete_an_entry
    entry = @proxy.create_entry(@user, :running) do |e|
      e.comment = 'test'
      e.number_of_rounds = 10
      e.public_visible = Coach4rb::Privacy::Public
    end

    assert entry
    assert @proxy.entry_by_uri entry.uri
    assert @proxy.delete_entry(entry)
    sleep 2
    refute @proxy.entry_by_uri(entry.uri)

  end


end