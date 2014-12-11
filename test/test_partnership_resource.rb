require 'test/test_helper'

class TestPartnershipResource < MiniTest::Test

  def setup
    @partnership_hash = {
        :uri => "/CyberCoachServer/resources/partnerships/newuser4;newuser5/",
        :id => 5,
        :userconfirmed1 => true,
        :userconfirmed2 => true,
        :datecreated => 1412672125000,
        :publicvisible => 2,
        :user1 =>
            {
                :uri => "/CyberCoachServer/resources/users/newuser4/",
                :username => "newuser4"
            },
        :user2 =>
            {
                :uri => "/CyberCoachServer/resources/users/newuser5/",
                :username => "newuser5"
            },
        :subscriptions =>
            [{:uri => "/CyberCoachServer/resources/partnerships/newuser4;newuser5/Soccer/",
              :id => 10}]
    }
  end


  def test_should_create_partnership_from_hash
    partnership =  Coach4rb::Resource::Partnership.from_coach @partnership_hash
    assert partnership

    @partnership_hash.each do |key,value|
      if key == :datecreated
        assert_equal Time.at(@partnership_hash[key]/1000).to_datetime, partnership.send(key)
      elsif key == :subscriptions
        assert partnership.subscriptions
      elsif key == :user1 || key == :user2
        assert partnership.first_user
        assert partnership.second_user
      else
        assert_equal @partnership_hash[key], partnership.send(key)
        assert_equal @partnership_hash[key], partnership[key]
      end
    end

  end


  def test_should_read_properties_using_methods
    partnership =  Coach4rb::Resource::Partnership.from_coach @partnership_hash
    assert partnership
    assert_equal @partnership_hash[:uri], partnership.uri
    assert_equal @partnership_hash[:user1][:username], partnership.first_user.username
    assert_equal @partnership_hash[:user1][:username], partnership.user1.username
  end


  def test_should_read_properties_using_hash_like_access
    partnership =  Coach4rb::Resource::Partnership.from_coach @partnership_hash
    assert partnership
    assert_equal @partnership_hash[:uri], partnership[:uri]
    assert_equal @partnership_hash[:user1][:username], partnership[:first_user].username
    assert_equal @partnership_hash[:user1][:username], partnership[:user1].username
  end


end