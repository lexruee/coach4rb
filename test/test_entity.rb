require 'test/test_helper'

class TestEntity < MiniTest::Test

  def setup
    @user_hash = {
        :uri => "/CyberCoachServer/resources/users/arueedlinger/",
        :links =>
            [{:href => "/CyberCoachServer/resources/users/arueedlinger/?start=5&size=5",
              :description => "next"}],
        :username => "arueedlinger",
        :password => "*",
        :realname => "Alexander Rueedlinger 2",
        :email => "a.rueedlinger@gmail.com",
        :datecreated => 1413590323000,
        :publicvisible => 2,
        :partnerships =>
            [{:uri => "/CyberCoachServer/resources/partnerships/arueedlinger;asarteam5/",
              :id => 291},
             {:uri => "/CyberCoachServer/resources/partnerships/arueedlinger;asarteam4/",
              :id => 292},
             {:uri => "/CyberCoachServer/resources/partnerships/arueedlinger;asarteam3/",
              :id => 337},
             {:uri => "/CyberCoachServer/resources/partnerships/arueedlinger;asarteam2/",
              :id => 345},
             {:uri => "/CyberCoachServer/resources/partnerships/mikeshiva;arueedlinger/",
              :id => 372}],
        :subscriptions =>
            [{:uri => "/CyberCoachServer/resources/users/arueedlinger/Running/", :id => 227},
             {:uri => "/CyberCoachServer/resources/users/arueedlinger/Boxing/", :id => 228},
             {:uri => "/CyberCoachServer/resources/users/arueedlinger/Soccer/", :id => 229},
             {:uri => "/CyberCoachServer/resources/users/arueedlinger/Cycling/",
              :id => 230}]
    }
  end


  def test_should_create_entity_resource
    resource = Coach4rb::Resource::Entity.from_coach @user_hash
    assert_equal @user_hash[:uri], resource.uri
    assert_equal @user_hash[:username], resource[:username]
  end


  def test_should_have_hash_like_access
    resource = Coach4rb::Resource::Page.from_coach @user_hash
    assert_equal @user_hash[:uri], resource[:uri]
    assert_equal @user_hash[:username], resource[:username]
  end


  def test_should_iterate_over_properties
    resource = Coach4rb::Resource::Entity.from_coach @user_hash
    @user_hash.each do |key, value|
      if key == :datecreated
        assert_equal value, resource[key]
      else
        assert_equal value, resource[key]
      end
    end
  end

end