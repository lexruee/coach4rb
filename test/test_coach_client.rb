require 'test/test_helper'

class CoachTestRetrieval < MiniTest::Test

  def setup
    @coach = Coach4rb.configure(
        scheme: 'http',
        host: 'diufvm31.unifr.ch',
        port: 8090,
        path: '/CyberCoachServer/resources',
        debug: true
    )
  end


  def test_if_cyber_coach_is_available
    assert @coach.available?
  end


end