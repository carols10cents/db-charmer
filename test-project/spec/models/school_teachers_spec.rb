require 'spec_helper'

def puts_db
  [:schools_shard_one, :schools_shard_two].each do |shard|
    puts "On shard #{shard}"
    puts "Schools = #{School.shard_for(shard).all.inspect}"
    puts "Teachers = #{Teacher.shard_for(shard).all.inspect}"
  end
end

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    [:schools_shard_one, :schools_shard_two].each do |shard|
      School.shard_for(shard).delete_all
      Teacher.shard_for(shard).delete_all
    end

    @school = School.create!
  end

  describe "school" do
    it "has a shard id" do
      @school.shard_id.should == :schools_shard_one
    end

    it "is on the shard that all schools are hardcoded to be on" do
      School.shard_for(:schools_shard_one).first.id.should be @school.id
      School.shard_for(:schools_shard_two).count.should == 0
    end
  end


  describe "teacher" do
    before do
      @teacher = @school.teachers.create!
    end

    it "has a school id" do
      @teacher.school_id.should_not be_nil
    end

    it "is on the shard that it looked up from the school" do
      Teacher.shard_for(:schools_shard_one).first.id.should be @teacher.id
      Teacher.shard_for(:schools_shard_two).count.should == 0
    end
  end
end