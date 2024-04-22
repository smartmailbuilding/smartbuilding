class AddPriceToValordoses < ActiveRecord::Migration[7.0]
  def change
    add_column :valordoses, :price, :decimal
  end
end
