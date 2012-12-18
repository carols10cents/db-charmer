require 'spec_helper'

describe "Schools and teachers - shard choice is dependent" do
  before(:each) do
    ['one', 'two'].each do |shard|
      School.shard_for(shard).delete_all
      Teacher.shard_for(shard).delete_all
    end

    @school = School.shard_for('one').create!

    puts "school = #{@school.inspect}"

    # Some of these tests pass if we do this:
    # @teacher = @school.teachers.shard_for('1').create!
    # but we don't want to have to do that.

    # We expect to be able to do:
    @teacher = @school.teachers.create!
    puts "teacher = #{@teacher.inspect}"
    puts "================"
    puts "School Shard 1: #{School.on_db(:schools_shard_one).all.inspect}"
    puts "Teacher Shard 1: #{Teacher.on_db(:schools_shard_one).all.inspect}"
    puts "================"
    puts "School Shard 1: #{School.on_db(:schools_shard_two).all.inspect}"
    puts "Teacher Shard 1: #{Teacher.on_db(:schools_shard_one).all.inspect}"
  end

  describe "teacher" do
    it "is on the same shard as the school" do
      teacher_conn = @teacher.connection.real_connection.connection_name
      school_conn = @school.connection.real_connection.connection_name

      teacher_conn.should == school_conn
    end

    it "has a school on the same shard" do
      tsc = @teacher.school.connection.real_connection.connection_name
      tc = @teacher.connection.real_connection.connection_name
      tsc.should == tc
    end
  end

  describe "school" do
    it "has a teacher on the same shard" do
      stc = @school.teachers.first.connection.real_connection.connection_name
      sc =  @school.connection.real_connection.connection_name
      stc.should == sc
    end
  end
end