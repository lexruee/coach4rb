require 'test/test_helper'

class TestPage < MiniTest::Test

  def setup
    @users_hash = {
        :uri => "/CyberCoachServer/resources/users/",
        :links =>
            [{:href => "/CyberCoachServer/resources/users/?start=5&size=5",
              :description => "next"}],
        :start => 0,
        :end => 5,
        :available => 1501,
        :type => "users",
        :users =>
            [{:uri => "/CyberCoachServer/resources/users/a20141117144353789/",
              :username => "a20141117144353789"},
             {:uri => "/CyberCoachServer/resources/users/a20141117234855862/",
              :username => "a20141117234855862"},
             {:uri => "/CyberCoachServer/resources/users/a20141119104037912/",
              :username => "a20141119104037912"},
             {:uri => "/CyberCoachServer/resources/users/a20141119114643946/",
              :username => "a20141119114643946"},
             {:uri => "/CyberCoachServer/resources/users/a20141119120107236/",
              :username => "a20141119120107236"}]
    }

  end


  def test_should_create_page_resource
    resource = Coach4rb::Resource::Page.from_coach @users_hash, Coach4rb::Resource::User
    assert_equal @users_hash[:uri], resource.uri
    assert_equal 5, resource.items.size
    assert_equal 0, resource.start
    assert_equal 5, resource.end
    assert_equal 1501, resource.available
  end

  def test_should_get_users_from_page_resource
    resource = Coach4rb::Resource::Page.from_coach @users_hash, Coach4rb::Resource::User
    users = resource.to_a
    users.each do |user|
      assert user.is_a? Coach4rb::Resource::User
    end

    resource.entities.each do |user|
      assert user.is_a? Coach4rb::Resource::User
    end


    resource.items.each do |user|
      assert user.is_a? Coach4rb::Resource::User
    end

  end


  def test_should_have_hash_like_access
    resource = Coach4rb::Resource::Page.from_coach @users_hash, Coach4rb::Resource::User
    assert_equal @users_hash[:uri], resource[:uri]
  end


  def test_should_iterate_over_properties
    resource = Coach4rb::Resource::Page.from_coach @users_hash, Coach4rb::Resource::User
    @users_hash.each do |key, value|
      assert_equal value, resource[key]
    end
  end

  def test_should_read_page_items
    users = Coach4rb::Resource::Page.from_coach @users_hash, Coach4rb::Resource::User
    users.each do |user|
      assert user
      assert user.username
      assert user.uri
    end
  end


end