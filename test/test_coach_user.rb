require 'test/test_helper'

class TestUserCoach < MiniTest::Test

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host:  'diufvm31.unifr.ch',
        port:  8090,
        path:  '/CyberCoachServer/resources',
        debug: true
    )
  end


  def test_should_get_a_user_by_its_username
    user = @coach.user 'arueedlinger'
    assert user
    assert user.is_a? Coach4rb::Resource::User
    assert_equal 'arueedlinger', user.username
  end



  def test_should_get_user_by_its_resource_object
    user = @coach.user 'arueedlinger'
    assert_equal 'arueedlinger', user.username
    user = @coach.user user
    assert_equal 'arueedlinger', user.username
  end



  def test_should_get_a_user_by_its_uri
    user = @coach.user_by_uri '/CyberCoachServer/resources/users/arueedlinger'
    assert user
    assert user.is_a? Coach4rb::Resource::User
    assert_equal 'arueedlinger', user.username
  end



  def test_should_get_user_details
    users = @coach.users
    users = users.map { |u| @coach.user u.username }
    users.each do |user|
      refute_nil user.email
      refute_nil user.username
      refute_nil user.real_name
      refute_nil user.created
    end
  end



  def test_should_get_some_users
    users = @coach.users
    assert users
    assert_equal 5, users.size

    users = @coach.users {}
    assert users
    assert_equal 5, users.size

    users = @coach.users query: {start: 0, size: 10}
    assert users
    assert_equal 10, users.size
    assert_equal 0, users.start
    assert_equal 10, users.end

    assert users.is_a? Coach4rb::Resource::Page
    users.each do |user|
      assert user.is_a? Coach4rb::Resource::Entity
      assert user.uri
      fetched_user = @coach.user user.username
      assert fetched_user.is_a? Coach4rb::Resource::User
    end
  end



  def test_should_get_10_users
    users = @coach.users query: {start: 0, size: 10}
    assert_equal 10, users.size
    10.times do |i|
      assert users[i]
      assert users[i].is_a? Coach4rb::Resource::User
    end

    first_user = users.first
    assert first_user
    assert first_user.is_a? Coach4rb::Resource::User
  end



  def test_username_should_not_be_available
    refute @coach.username_available? 'arueedlinger'
  end


  def test_username_should_be_available
    assert @coach.username_available? 'arueedlinger1111111'
  end


  def test_user_should_exist
    assert @coach.user_exists?('arueedlinger')
  end


  def test_user_should_not_exist
    refute @coach.user_exists?('arueedlinger1111111')
  end



  def test_should_authenticate_user
    user = @coach.authenticate('arueedlinger','test')
    assert user
    assert user.is_a?(Coach4rb::Resource::User)
    assert user.real_name
  end


  def test_should_not_authenticate_user
    assert @coach.authenticate('arueedlinger','sajdhjkasdjka') == false
  end


  def test_should_create_a_user
    @coach.create_user do |user|
      user.real_name = 'the hoff'
      user.username = 'wantsomemoney' + DateTime.now.to_time.to_i.to_s
      user.password = 'test'
      user.email = 'test@test.com'
      user.public_visible = Coach4rb::Privacy::Public
    end
  end


  def test_should_create_and_delete_user
    username = 'wantsomemoney' + DateTime.now.to_time.to_i.to_s
    proxy = Coach4rb::Proxy::Access.new(username,'test', @coach)
    user = proxy.create_user do |user|
      user.real_name = 'the hoff'
      user.username = username
      user.password = 'test'
      user.email = 'test@test.com'
      user.public_visible = Coach4rb::Privacy::Public
    end
    assert user
    assert_equal username, user.username
    sleep 2

    assert proxy.delete_user(username)

  end


  def test_should_update_a_user
    proxy = Coach4rb::Proxy::Access.new 'wantsomemoney', 'test', @coach

    before_update_user = @coach.user 'wantsomemoney'
    assert_equal '007!!!', before_update_user.real_name

    @coach.user 'wantsomemoney'
    result = proxy.update_user(before_update_user) do |user|
      user.real_name = 'James Bond!'
    end

    after_update_user = @coach.user 'wantsomemoney'
    assert_equal 'James Bond!', after_update_user.real_name

    @coach.user 'wantsomemoney'
    result = proxy.update_user(after_update_user) do |user|
      user.real_name = '007!!!'
    end
    updated_user = @coach.user 'wantsomemoney'
    assert_equal '007!!!', updated_user.real_name
  end


  def test_should_update_a_user_by_its_uri
    proxy = Coach4rb::Proxy::Access.new 'arueedlinger', 'test', @coach
    user = @coach.user 'arueedlinger'
    user = proxy.update_user(user.uri) do |user|
      user.real_name = 'Alex Rueedlinger'
    end
    assert_equal 'Alex Rueedlinger', user.real_name
  end


end