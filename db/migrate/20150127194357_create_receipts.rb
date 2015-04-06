class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :user, index: true
      t.integer :amount
      t.string :paypal_id
      t.text :full_paypal_hash
      t.boolean :by_check, default: false
      t.integer :check_num
      t.string :bank
      t.date :check_dated

      t.timestamps
    end
  end
end
