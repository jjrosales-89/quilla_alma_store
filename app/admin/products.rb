ActiveAdmin.register Product do
  permit_params(
    :category_id,
    :name,
    :description,
    :price,
    :stock_quantity,
    :on_sale,
    :sale_price,
    :image,
    tag_ids: []
  )

  config.filters = false

  index do
    selectable_column
    id_column
    column :name

    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image), width: 70, alt: product.name
      else
        "No image"
      end
    end

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

      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), width: 300, alt: product.name
        else
          "No image uploaded"
        end
      end

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

    # This prevents Rails from generating a URL for an image blob that has not yet been saved.
    image_hint =
      if f.object.image.attached? && f.object.image.blob.persisted?
        image_tag(
          url_for(f.object.image),
          width: 200,
          alt: f.object.name
        )
      else
        "Upload a JPEG, PNG, or WebP image smaller than 5 MB."
      end

    f.input :image, as: :file, hint: image_hint

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
