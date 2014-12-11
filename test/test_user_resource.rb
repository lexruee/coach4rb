require 'test/test_helper'

class UserTest < MiniTest::Test

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



  def test_should_create_user_from_hash
    user = Coach4rb::Resource::User.from_coach @user_hash

    assert user

    @user_hash.each do |key,value|
      if key == :datecreated
        assert_equal Time.at(@user_hash[key]/1000).to_datetime, user.send(key)
      elsif key == :password
        assert_nil user.password
      elsif key == :partnerships
        assert user.partnerships
        user.partnerships.each do |p|
          assert p.is_a?(Coach4rb::Resource::Partnership)
        end
      elsif key == :subscriptions
        user.subscriptions.each do |s|
          assert s.is_a?(Coach4rb::Resource::Subscription)
        end
      else
        assert_equal @user_hash[key], user.send(key)
        assert_equal @user_hash[key], user[key]
      end

    end
  end


  def test_should_read_properties_using_methods
    user = Coach4rb::Resource::User.from_coach @user_hash
    assert user
    assert_equal @user_hash[:realname], user.real_name
    assert_equal @user_hash[:username], user.username
    assert_equal @user_hash[:email], user.email
    assert_equal Time.at(@user_hash[:datecreated]/1000).to_datetime, user.created
    assert_equal @user_hash[:uri], user.uri
  end


  def test_should_read_properties_using_hash_like_access
    user = Coach4rb::Resource::User.from_coach @user_hash
    assert user
    assert_equal @user_hash[:realname], user[:real_name]
    assert_equal @user_hash[:username], user[:username]
    assert_equal @user_hash[:email], user[:email]
    assert_equal Time.at(@user_hash[:datecreated]/1000).to_datetime, user[:created]
    assert_equal @user_hash[:uri], user[:uri]
  end


  def test_should_read_partnerships
    user = Coach4rb::Resource::User.from_coach @user_hash
    assert user
    user.partnerships.each do |partnership|
      assert partnership.uri
    end
  end


  def test_should_create_hash_from_user
    user = Coach4rb::Resource::User.from_coach @user_hash
    pp user.to_hash
  end


end