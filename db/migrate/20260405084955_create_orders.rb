class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :product_name
      t.decimal :amount
      t.string :status
      t.date :placed_on

      t.timestamps
    end
  end
end
