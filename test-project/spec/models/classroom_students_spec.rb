require 'spec_helper'

describe "Classroom and student relations" do
  before(:each) do
    @classroom = Classroom.create!
    @student = Student.create!
    @classroom.students << @student
  end

  describe "student" do
    it "is on the enrollments shard" do
       @student.connection.object_id.should == Student.on_db(:enrollments).connection.object_id
    end

    it "has a classroom in the master shard" do
      @student.classrooms.first.connection.object_id.should == Classroom.on_db(:master).connection.object_id
    end
  end

  describe "classroom" do
    it "has a student on the enrollment shard" do
      @classroom.students.first.connection.object_id.should == Student.on_db(:enrollments).connection.object_id
    end
  end
end