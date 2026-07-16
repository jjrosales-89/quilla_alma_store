ActiveAdmin.register Category do
  permit_params :name, :description

  # Avoid automatic Ransack filters until searchable fields are configured.
  config.filters = false

  index do
    selectable_column
    id_column
    column :name
    column("Products") { |category| category.products.count }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Products in this category" do
      table_for resource.products.order(:name) do
        column :name do |product|
          link_to product.name, admin_product_path(product)
        end
        column :price
        column :stock_quantity
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Category details" do
      f.input :name
      f.input :description
    end

    f.actions
  end
end
