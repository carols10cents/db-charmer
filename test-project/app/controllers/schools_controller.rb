class SchoolsController < ApplicationController
  before_filter do
    @request_shard = :schools_shard_two
  end

  def show
    @school = School.find(params[:id])
    @teacher = @school.teachers.first
  end
end
