class ChangePrimaryKeyOnCourseModules < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE course_modules DROP CONSTRAINT course_modules_pkey"
    execute "ALTER TABLE course_modules ADD CONSTRAINT course_modules_pkey PRIMARY KEY (id)"
  end

  def down
    execute "ALTER TABLE course_modules DROP CONSTRAINT course_modules_pkey"
    execute "ALTER TABLE course_modules ADD CONSTRAINT course_modules_pkey PRIMARY KEY (code)"
  end
end
