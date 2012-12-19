class Teacher < ActiveRecord::Base
  db_magic :sharded => {
    sharded_connection: :schools
  }

  belongs_to :school
end