require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    ['one', 'two'].each do |shard|
      School.shard_for(shard).delete_all
      Teacher.shard_for(shard).delete_all
    end

    @school = School.create!
  end

  describe "school" do
    it "is on the default shard" do
      School.shard_for('one').first.id.should be @school.id
    end
  end


  describe "teacher" do
    before do
      @teacher = @school.teachers.create!
    end

    it "has a school id" do
      @teacher.school_id.should_not be_nil
    end

    it "is on the default shard" do
      Teacher.shard_for('one').first.id.should be @teacher.id
    end
  end
end