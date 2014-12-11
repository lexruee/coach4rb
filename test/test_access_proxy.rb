require 'test/test_helper'

class TestAccessProxy < MiniTest::Test
  include Coach4rb::Mixin::BasicAuth

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources'
    )
    @proxy = Coach4rb::Proxy::Access.new'privatealex', 'scareface', @coach
    @invalid_proxy = Coach4rb::Proxy::InvalidAccess.new @coach
  end


  def test_should_still_work_using_a_proxy
    partnerships = @proxy.partnerships query: {start: 0, size: 10}
    assert partnerships
    assert_equal 10, partnerships.size
  end

  def test_access_on_private_resource_without_a_proxy
    user = @coach.user 'privatealex', {authorization: basic_auth_encription('privatealex','test')}
    assert user
    assert user.username
  end

  def test_access_on_private_resource_without_a_proxy
    users = @coach.users query: { start: 0, size: 2000 }, authorization: basic_auth_encryption('privatealex','test')
    user = users.detect { |u| u.username == 'privatealex' }
    assert user
    assert user.username

  end

  def test_should_test_proxy_access
    assert @proxy.valid?
    assert @proxy.available?
    user = @proxy.user 'privatealex'
    assert user
    assert user.real_name
    assert user.email
    assert user.username
    assert_equal Coach4rb::Privacy::Private, user.public_visible
  end



  def test_should_test_invalid_proxy_access
    assert @invalid_proxy.available?
    refute @invalid_proxy.valid?
  end



end