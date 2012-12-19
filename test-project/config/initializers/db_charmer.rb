DbCharmer.connections_should_exist = false # Since we are not in production
DbCharmer.enable_controller_magic!

DbCharmerSandbox::Application.configure do
  config.shards = [ :schools_shard_one, :schools_shard_two]
end