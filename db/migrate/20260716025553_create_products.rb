class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, null: false, default: 0
      t.boolean :on_sale, null: false, default: false
      t.decimal :sale_price, precision: 10, scale: 2

      t.timestamps
    end

    add_index :products, :name
  end
end
