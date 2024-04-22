class CreateValordoses < ActiveRecord::Migration[7.0]
  def change
    create_table :valordoses do |t|
      t.decimal :value

      t.timestamps
    end
  end
end
