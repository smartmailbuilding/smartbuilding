class CreateEmployeeActions < ActiveRecord::Migration[6.0]
  def change
    create_table :employee_actions do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :action_type
      t.text :action_description
      t.timestamps
    end
  end
end