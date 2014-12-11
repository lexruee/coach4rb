require 'test/test_helper'

class TestCoachPartnership < MiniTest::Test

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources',
        debug: true
    )
  end


  def test_should_create_partnership
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    assert proxy.create_partnership('arueedlinger','wanze2')
  end


  def test_should_create_and_delete_partnership
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    partnership = proxy.create_partnership('arueedlinger','wantsomemoney')
    assert partnership
    sleep 2
    assert proxy.delete_partnership(partnership)
  end


  def test_should_breakup_between_users
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    partnership = proxy.create_partnership('arueedlinger','wantsomemoney')
    assert partnership
    sleep 2
    assert proxy.breakup_between('arueedlinger', 'wantsomemoney')
  end


  def test_get_partnership_details_of_a_user
    user = @coach.user 'arueedlinger'
    partnerships = user.partnerships.map { |p| @coach.partnership_by_uri p.uri }
    partnerships.each do |p|
      assert p
      assert p.first_user.username
      assert p.first_user.uri
      assert p.second_user.username
      assert p.first_user.uri
    end
  end


  def test_should_get_a_partnership
    partnership = @coach.partnership 'mikeshiva', 'arueedlinger'
    assert partnership
    assert partnership.uri
    assert partnership.first_user_confirmed
    assert partnership.second_user_confirmed
    assert partnership.first_user
    assert partnership.second_user
    first_user = @coach.user_by_uri partnership.first_user[:uri]
    assert_equal 'mikeshiva', first_user.username
  end



  def test_should_get_a_partnership_by_its_uri
    partnership = @coach.partnership_by_uri '/CyberCoachServer/resources/partnerships/arueedlinger;asarteam5/'
    assert partnership
    assert partnership.uri
    assert partnership.first_user_confirmed
    assert partnership.second_user_confirmed
    assert partnership.first_user
    assert partnership.second_user
  end



  def test_should_get_partnerships
    partnerships = @coach.partnerships
    assert partnerships
    assert_equal 5, partnerships.size

    partnerships = @coach.partnerships {}
    assert partnerships
    assert_equal 5, partnerships.size

    partnerships = @coach.partnerships query: {start: 0, size: 10}
    assert partnerships
    assert_equal 10, partnerships.size
    assert_equal 0, partnerships.start
    assert_equal 10, partnerships.end

    10.times do |i|
      assert partnerships[i]
    end
  end



  def test_should_get_10_partnerships
    partnerships = @coach.partnerships query: {start: 0, size: 10}
    assert partnerships.items
    assert_equal 10, partnerships.size
    10.times do |i|
      assert partnerships[i]
      assert partnerships[i].is_a? Coach4rb::Resource::Partnership
    end

    first_partnership = partnerships.first
    assert first_partnership
    assert first_partnership.is_a? Coach4rb::Resource::Partnership
  end

end