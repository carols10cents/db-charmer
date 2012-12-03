class CreateClassroomsAndStudents < ActiveRecord::Migration
  def change
    create_table :classrooms
    create_table :classroom_students do |t|
      t.integer :classroom_id
      t.integer :student_id
    end

    on_db :enrollments do
      create_table :students
    end
  end
end
