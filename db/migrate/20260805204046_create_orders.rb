class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer,
                   null: false,
                   foreign_key: true

      t.string :status,
               null: false,
               default: "pending"

      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :city, null: false
      t.string :province_name, null: false
      t.string :province_code, null: false
      t.string :postal_code, null: false

      t.decimal :subtotal,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.decimal :gst_rate,
                precision: 5,
                scale: 4,
                default: 0,
                null: false

      t.decimal :pst_rate,
                precision: 5,
                scale: 4,
                default: 0,
                null: false

      t.decimal :hst_rate,
                precision: 5,
                scale: 4,
                default: 0,
                null: false

      t.decimal :gst_amount,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.decimal :pst_amount,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.decimal :hst_amount,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.decimal :total,
                precision: 10,
                scale: 2,
                default: 0,
                null: false

      t.datetime :placed_at

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :placed_at
  end
end
