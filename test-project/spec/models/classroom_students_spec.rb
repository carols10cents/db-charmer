require 'spec_helper'

describe "Classroom and student related with has_many :through" do
  before(:each) do
    @classroom = Classroom.create!
    @student = Student.create!
    @classroom.students << @student
  end

  describe "student" do
    it "is on the non-master shard" do
      student_connection = @student.connection.object_id
      shard_connection = Student.on_db(:enrollments).connection.object_id

      student_connection.should == shard_connection
    end

    it "has a classroom in the master shard" do
      classroom_connection = @student.classrooms.first.connection.object_id
      master_connection = Classroom.on_db(:master).connection.object_id
      classroom_connection.should == master_connection
    end
  end

  describe "classroom" do
    it "can find its students on the other shard by doing a second query" do
      student_ids = @classroom.classroom_students.pluck(:student_id).uniq
      students = Student.find(student_ids)

      first_student = students.first
      first_student_connection = first_student.connection.object_id
      student_connection = Student.on_db(:enrollments).connection.object_id

      first_student_connection.should == student_connection
    end

    it "cannot query the has_many :students" do
      expect {
        @classroom.students.all
      }.to raise_exception ActiveRecord::StatementInvalid
    end

    it "cannot use the student_ids method" do
      expect {
        @classroom.student_ids
      }.to raise_exception ActiveRecord::StatementInvalid
    end

    it "cannot ask if students is empty" do
      expect {
        @classroom.students.empty?
      }.to raise_exception ActiveRecord::StatementInvalid
    end

    it "cannot ask the size of students" do
      expect {
        @classroom.students.size
      }.to raise_exception ActiveRecord::StatementInvalid
    end
  end
end