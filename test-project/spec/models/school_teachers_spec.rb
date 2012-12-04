require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    @school = School.shard_for('1').create!

    # Some of these tests pass if we do this:
    # @teacher = @school.teachers.shard_for('1').create!
    # but we don't want to have to do that.

    # We expect to be able to do:
    @teacher = @school.teachers.create!
  end

  describe "teacher" do
    it "is on the same shard as the school" do
      @teacher.connection.object_id.should == @school.connection.object_id
    end

    it "has a school on the same shard" do
      @teacher.school.connection.object_id.should == @teacher.connection.object_id
    end
  end

  describe "school" do
    it "has a teacher on the same shard" do
      @school.teachers.first.connection.object_id == @school.connection.object_id
    end
  end
end