class Teacher < ActiveRecord::Base
  db_magic :connection => :schools

  belongs_to :school
end