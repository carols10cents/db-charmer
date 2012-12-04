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
    it "has a student on the enrollment shard (workaround)" do
      student_ids = @classroom.classroom_students.pluck(:student_id).uniq
      classroom_students = Student.find(student_ids)

      first_student = classroom_students.first
      first_student.connection.object_id.should == Student.on_db(:enrollments).connection.object_id
    end

    it "has students" do
      @classroom.students.should_not == []
    end

    it "has student_ids" do
      @classroom.student_ids.should_not be_empty
    end

    it "can ask if it's empty" do
      @classroom.students.empty?.should be_false
    end

    it "can ask the size" do
      @classroom.students.size.should == 1
    end
  end
end