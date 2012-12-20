class Teacher < ActiveRecord::Base
  db_magic :sharded => {
    sharded_connection: :schools,
    key: :shard_id
  }

  around_save :set_shard

  def set_shard(&block)
    on_db(shard_id) do
      block.call
    end
  end

  def shard_id
    puts "school = #{self.school.inspect}"
    School.find(school_id).shard_id
  end

  belongs_to :school
end