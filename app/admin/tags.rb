ActiveAdmin.register Tag do
  permit_params :name

  config.filters = false

  index do
    selectable_column
    id_column
    column :name
    column("Products") { |tag| tag.products.count }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Products using this tag" do
      table_for resource.products.order(:name) do
        column :name do |product|
          link_to product.name, admin_product_path(product)
        end
        column :category
        column :price
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Tag details" do
      f.input :name
    end

    f.actions
  end
end
