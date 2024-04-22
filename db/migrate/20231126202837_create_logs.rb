class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.text :employee_info
      t.text :message

      t.timestamps
    end
  end
end
