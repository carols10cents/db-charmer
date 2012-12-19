DbCharmer.connections_should_exist = false # Since we are not in production
DbCharmer.enable_controller_magic!

class DbCharmer::Sharding::Method::PerRequest
  def initialize(config)
  end

  def shard_for_key(key)
    # Ignore key and look for the global value
    ApplicationController.request_shard
  end

  def support_default_shard?
    true
  end
end

DbCharmer::Sharding.register_connection(
  :name   => :schools,
  :method => :per_request
)

DbCharmerSandbox::Application.configure do
  # should match names in database.yml
  config.shards = [:schools_shard_one, :schools_shard_two]
end