DbCharmer.connections_should_exist = false # Since we are not in production
DbCharmer.enable_controller_magic!

SHARDING_MAP = {
    '1' => :schools_shard_one,
    '2' => :schools_shard_two,
    :default => :schools_shard_two
}

DbCharmer::Sharding.register_connection(
    :name   => :schools,
    :method => :hash_map,
    :map    => SHARDING_MAP
)

DbCharmerSandbox::Application.configure do
  # BEGIN: SHARDING CUSTOMIZATION

  # should match names in database.yml
  config.shards = [ :schools_shard_one, :schools_shard_two]
end