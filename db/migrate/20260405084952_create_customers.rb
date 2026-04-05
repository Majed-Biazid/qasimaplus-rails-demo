class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :plan
      t.string :company
      t.date :joined_on

      t.timestamps
    end
  end
end
