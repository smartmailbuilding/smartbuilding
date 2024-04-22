class CreateKeylockers < ActiveRecord::Migration[7.0]
  def change
    create_table :keylockers do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :complement
      t.string :neighborhood
      t.string :nameBuilding
      t.timestamps
    end
  end
end