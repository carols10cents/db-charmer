require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    [:schools_shard_one, :schools_shard_two].each do |shard|
      School.on_db(shard).delete_all
      Teacher.on_db(shard).delete_all
    end

    # Simulate controller around filter
    DbCharmer.with_remapped_databases(:schools => :schools_shard_one) do
      @school = School.create!
    end
  end

  describe "school" do
    it "is on the remapped shard" do
      School.on_db(:schools_shard_two).all.should be_empty
      School.on_db(:schools_shard_one).first.id.should be @school.id
    end
  end


  describe "teacher" do
    before do
      # Simulate controller around filter
      DbCharmer.with_remapped_databases(:schools => :schools_shard_one) do
        @teacher = @school.teachers.create!
      end
    end

    it "has a school id" do
      @teacher.school_id.should_not be_nil
    end

    it "is on the remapped shard" do
      Teacher.on_db(:schools_shard_two).all.should be_empty
      Teacher.on_db(:schools_shard_one).first.id.should be @teacher.id
    end
  end
end