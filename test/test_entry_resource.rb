require 'test/test_helper'

class TestEntryResource < MiniTest::Test

  def setup
    @running_hash = {
        :entryrunning =>
            {:uri => "/CyberCoachServer/resources/users/arueedlinger/Running/646/",
             :id => 646,
             :datecreated => 1417784060000,
             :datemodified => 1417784060000,
             :entrylocation => "",
             :entrydate => 1418428800000,
             :entryduration => 0,
             :comment => "",
             :publicvisible => 2,
             :subscription =>
                 {:uri => "/CyberCoachServer/resources/users/arueedlinger/Running/",
                  :id => 227},
             :coursetype => "",
             :courselength => 0,
             :numberofrounds => 0}
    }
  end


  def test_should_create_running_from_hash
    running = Coach4rb::Resource::Entry.from_coach @running_hash
    assert running
    assert_equal @running_hash[:entryrunning][:uri], running.uri
    assert_equal @running_hash[:entryrunning][:numberofrounds], running.number_of_rounds
    assert running.created.is_a?(DateTime)
    assert running.modified.is_a?(DateTime)
  end

end