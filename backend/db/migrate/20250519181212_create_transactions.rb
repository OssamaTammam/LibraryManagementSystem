class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.bigint :user_id, null: false
      t.bigint :book_id, null: false
      t.decimal :price, null: false
      t.integer :transaction_type, null: false
      t.datetime :transaction_date, null: false
      t.datetime :return_date, null: true
    end

    add_foreign_key :transactions, :users, column: :user_id
    add_foreign_key :transactions, :books, column: :book_id
  end
end
