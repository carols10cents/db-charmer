require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    @school = School.shard_for('1').create!
    @teacher = @school.teachers.shard_for('1').create!
  end

  describe "teacher" do
    it "is on the same shard as the school" do
      @teacher.connection.object_id.should == @school.connection.object_id
    end
  end
end