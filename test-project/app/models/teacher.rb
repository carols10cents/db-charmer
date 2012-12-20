class Teacher < ActiveRecord::Base
  db_magic :sharded => {
    sharded_connection: :schools,
    key: :shard_id
  }

  belongs_to :school
end