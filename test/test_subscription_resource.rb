require 'test/test_helper'

class TestSubscriptionResource < MiniTest::Test

  def setup
    @subsription_hash ={
        :uri => "/CyberCoachServer/resources/users/newuser4/Running/",
        :id => 8,
        :datesubscribed => 1412671992000,
        :publicvisible => 2,
        :user =>
            {:uri => "/CyberCoachServer/resources/users/newuser4/", :username => "newuser4"},
        :sport =>
            {:uri => "/CyberCoachServer/resources/sports/Running/",
             :id => 1,
             :name => "Running"},
        :entries =>
            [{:entryrunning =>
                  {:uri => "/CyberCoachServer/resources/users/newuser4/Running/22/",
                   :id => 22,
                   :datecreated => 1412672016000,
                   :datemodified => 1412672016000}},
             {:entryrunning =>
                  {:uri => "/CyberCoachServer/resources/users/newuser4/Running/64/",
                   :id => 64,
                   :datecreated => 1414528248000,
                   :datemodified => 1414528248000}},
             {:entryrunning =>
                  {:uri => "/CyberCoachServer/resources/users/newuser4/Running/65/",
                   :id => 65,
                   :datecreated => 1414529021000,
                   :datemodified => 1414529021000}},
             {:entryrunning =>
                  {:uri => "/CyberCoachServer/resources/users/newuser4/Running/66/",
                   :id => 66,
                   :datecreated => 1414529032000,
                   :datemodified => 1414529032000}}]
    }

  end


  def test_should_create_subscription_from_hash
    subscription = Coach4rb::Resource::Subscription.from_coach @subsription_hash
    assert subscription
  end


  def test_should_read_entries
    subscription = Coach4rb::Resource::Subscription.from_coach @subsription_hash
    assert subscription.entries
    subscription.entries.each do |entry|
      assert entry.is_a? Coach4rb::Resource::Running
    end
  end


  def test_should_read_sport_property
    subscription = Coach4rb::Resource::Subscription.from_coach @subsription_hash
    assert subscription.sport
    assert subscription.sport.uri
  end


  def test_should_be_subscribed_to_running
    subscription = Coach4rb::Resource::Subscription.from_coach @subsription_hash
    assert subscription.sport? :running
    assert subscription.sport? :Running
    assert subscription.sport? 'running'
    assert subscription.sport? 'Running'
  end


end