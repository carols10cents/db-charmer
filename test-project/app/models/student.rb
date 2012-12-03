class Student < ActiveRecord::Base
  db_magic :connection => :enrollments

  has_many :classroom_students
  has_many :classrooms, through: :classroom_students, source: :classroom

end