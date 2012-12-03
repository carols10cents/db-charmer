class Teacher < ActiveRecord::Base
  db_magic :sharded => {
    key: :school_id, sharded_connection: :schools
  }

  belongs_to :school
end