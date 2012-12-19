class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :set_request_shard

  def set_request_shard(&block)
    DbCharmer.with_remapped_databases(:schools => :schools_shard_two, &block)
  end
end
