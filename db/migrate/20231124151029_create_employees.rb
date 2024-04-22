class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :lastname
      t.string :numberHouse
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
