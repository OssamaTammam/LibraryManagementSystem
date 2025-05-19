class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn, null: false
      t.integer :quantity, null: false
      t.decimal :buy_price, null: false
      t.decimal :borrow_price, null: false
      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :title
  end
end
