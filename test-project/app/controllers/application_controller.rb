class ApplicationController < ActionController::Base
  protect_from_forgery

  def request_shard
    @request_shard ||= :default
  end
end
