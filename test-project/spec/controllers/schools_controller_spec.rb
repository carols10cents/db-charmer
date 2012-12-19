require 'spec_helper'

describe SchoolsController do

  describe "GET 'show'" do
    before do
      [:schools_shard_one, :schools_shard_two].each do |shard|
        School.on_db(shard).delete_all
        Teacher.on_db(shard).delete_all
      end

      DbCharmer.with_remapped_databases(:schools => :schools_shard_two) do
        @school = School.create!
        @teacher = @school.teachers.create!
      end
    end

    it "should use the remapped connection set in application controller" do
      School.on_db(:schools_shard_one)
            .connection.should_not_receive(:select_value) # no counts
      School.on_db(:schools_shard_one)
            .connection.should_not_receive(:select_all) # no finds

      get 'show', :id => @school.id
    end
  end
end