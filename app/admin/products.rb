ActiveAdmin.register Product do
  permit_params(
    :category_id,
    :name,
    :description,
    :price,
    :stock_quantity,
    :on_sale,
    :sale_price,
    tag_ids: []
  )

  config.filters = false

  index do
    selectable_column
    id_column
    column :name
    column :category

    column :price do |product|
      number_to_currency(product.price)
    end

    column :stock_quantity
    column :on_sale

    column :tags do |product|
      product.tags.order(:name).pluck(:name).join(", ")
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :category
      row :description

      row :price do |product|
        number_to_currency(product.price)
      end

      row :stock_quantity
      row :on_sale

      row :sale_price do |product|
        product.sale_price.present? ? number_to_currency(product.sale_price) : "Not applicable"
      end

      row :tags do |product|
        product.tags.order(:name).pluck(:name).join(", ")
      end

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Product details" do
      f.input(
        :category,
        collection: Category.order(:name).map { |category| [category.name, category.id] },
        include_blank: false
      )

      f.input :name
      f.input :description
      # Explicit limits prevent Formtastic from guessing decimal minimum values.
      f.input :price, min: 0.01, step: 0.01
      f.input :stock_quantity, min: 0, step: 1
      f.input :on_sale
      f.input :sale_price, min: 0.01, step: 0.01

      # Tag selections are persisted through the ProductTag join model.
      f.input(
        :tags,
        as: :check_boxes,
        collection: Tag.order(:name).map { |tag| [tag.name, tag.id] }
      )
    end

    f.actions
  end
end
