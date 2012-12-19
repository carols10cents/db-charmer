require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    ['one', 'two'].each do |shard|
      School.shard_for(shard).delete_all
      Teacher.shard_for(shard).delete_all
    end

    @school = School.shard_for('one').create!
  end

  describe "teacher" do
    describe "using on_db" do
      it "has a school id" do
        @teacher = @school.on_db(:schools_shard_one).teachers.create!
        @teacher.school_id.should_not be_nil
      end
    end

    describe "using shard_for" do
      it "has a school id" do
        @teacher = @school.shard_for('one').teachers.create!
        @teacher.school_id.should_not be_nil
      end
    end

    # it "is on the same shard as the school" do
    #   teacher_conn = @teacher.connection.real_connection.connection_name
    #   school_conn = @school.connection.real_connection.connection_name
    #
    #   teacher_conn.should == school_conn
    # end

    # it "has a school on the same shard" do
    #   tsc = @teacher.school.connection.real_connection.connection_name
    #   tc = @teacher.connection.real_connection.connection_name
    #   tsc.should == tc
    # end
  end

  # describe "school" do
  #   it "has a teacher on the same shard" do
  #     stc = @school.teachers.first.connection.real_connection.connection_name
  #     sc =  @school.connection.real_connection.connection_name
  #     stc.should == sc
  #   end
  # end
end