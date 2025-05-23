class AddReturnedCol < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :returned, :boolean, default: false
  end
end
