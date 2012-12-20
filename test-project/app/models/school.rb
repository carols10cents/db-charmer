class School < ActiveRecord::Base
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
    :schools_shard_one
  end

  has_many :teachers do
    def on_dependent_shard
      on_db(proxy_association.owner.shard_id)
    end
  end

end