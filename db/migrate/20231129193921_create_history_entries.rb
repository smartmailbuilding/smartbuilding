class CreateHistoryEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :history_entries do |t|
      t.string :saveCards

      t.timestamps
    end
  end
end