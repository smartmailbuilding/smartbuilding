class AddUserIdToValordoses < ActiveRecord::Migration[7.0]
  def change
    add_reference :valordoses, :user, null: false, foreign_key: true
  end
end
