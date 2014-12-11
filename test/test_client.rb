require 'test/test_helper'

class TestClient < MiniTest::Test

  def setup
    @client = Coach4rb::Client.new(
        scheme: 'http',
        host:  'diufvm31.unifr.ch',
        port:  8090,
        path:  '/CyberCoachServer/resources'
    )
  end


  def test_should_have_path
    assert @client.path
    assert_equal  '/CyberCoachServer/resources', @client.path
  end


  def test_should_have_site
    assert 'http://diufvm31.unifr.ch/CyberCoachServer/resources', @client.site
  end


  def test_should_have_port
    assert 8090, @client.port
  end


  def test_should_have_host
    assert 'diufvm31.unifr.ch', @client.host
  end


  def test_should_have_scheme
    assert 'http', @client.scheme
  end


end