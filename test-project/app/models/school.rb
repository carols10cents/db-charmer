class School < ActiveRecord::Base
  db_magic :connection => :schools

  has_many :teachers
end