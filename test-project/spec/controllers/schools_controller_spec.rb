require 'spec_helper'

describe SchoolsController do
  describe "GET 'show'" do
    it "should use the other connection" do
      School.on_db(:schools_shard_one).connection.should_not_receive(:select_value) # no counts
      School.on_db(:schools_shard_one).connection.should_not_receive(:select_all) # no finds

      School.on_db(:schools_shard_two).connection.should_receive(:select_value).and_return(1)
      School.on_db(:schools_shard_two).connection.should_receive(:select_all).and_return(["1"])
      get 'show', :id => 1
    end
  end
end