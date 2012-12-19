class School < ActiveRecord::Base
  db_magic :sharded => {
    sharded_connection: :schools
  }

  has_many :teachers
end