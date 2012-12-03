class Classroom < ActiveRecord::Base

  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :student

end