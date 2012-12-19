class SchoolsController < ApplicationController
  def show
    @school = School.find(params[:id])
    @teacher = @school.teachers.first
  end
end
