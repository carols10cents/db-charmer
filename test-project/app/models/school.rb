class School < ActiveRecord::Base
  db_magic :sharded => {
    key: :school_id, sharded_connection: :schools
  }

  has_many :teachers
end