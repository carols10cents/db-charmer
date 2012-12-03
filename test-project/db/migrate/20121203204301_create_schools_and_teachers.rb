class CreateSchoolsAndTeachers < ActiveRecord::Migration
  db_magic :connections => DbCharmerSandbox::Application.config.shards

  def change
    create_table :teachers do |t|
      t.integer :school_id
    end
    create_table :schools
  end

end
