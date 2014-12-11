require 'test/test_helper'

class TestSportResource < MiniTest::Test


  def setup
    @sport_hash =
        {:uri=>"/CyberCoachServer/resources/sports/Running/",
         :links=>
             [{:href=>"/CyberCoachServer/resources/sports/Running/?start=5&size=5",
               :description=>"next"}],
         :id=>1,
         :name=>"Running",
         :description=>"Running Sport Description",
         :subscriptions=>
             [{:uri=>"/CyberCoachServer/resources/users/polchky/Running/", :id=>7},
              {:uri=>"/CyberCoachServer/resources/users/newuser4/Running/", :id=>8},
              {:uri=>
                   "/CyberCoachServer/resources/partnerships/asarteam1;asarteam2/Running/",
               :id=>62},
              {:uri=>"/CyberCoachServer/resources/users/alex/Running/", :id=>66},
              {:uri=>"/CyberCoachServer/resources/users/mydummy/Running/", :id=>149}]}
  end


  def test_should_create_sport_from_hash
    sport = Coach4rb::Resource::Sport.from_coach @sport_hash
    assert sport.uri
    assert sport.name

  end

end