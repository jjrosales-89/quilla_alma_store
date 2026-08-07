ActiveAdmin.register Order do
  menu priority: 5

  actions :all,
          except: %i[new create destroy]

  permit_params :status

  config.sort_order = "placed_at_desc"

  scope :all, default: true

  Order::STATUSES.each do |status|
    scope status.titleize do |orders|
      orders.where(status: status)
    end
  end

  filter :id
  filter :customer
  filter :customer_name
  filter :customer_email
  filter :status,
         as: :select,
         collection: Order::STATUSES
  filter :province_code
  filter :placed_at
  filter :total

  index do
    id_column

    column :customer_name
    column :customer_email

    column :status do |order|
      status_tag order.status
    end

    column :province_code

    column :subtotal do |order|
      number_to_currency(order.subtotal)
    end

    column :total do |order|
      number_to_currency(order.total)
    end

    column :placed_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :customer
      row :status do |order|
        status_tag order.status
      end
      row :placed_at
      row :customer_name
      row :customer_email
      row :address_line_1
      row :address_line_2
      row :city
      row :province_name
      row :province_code
      row :postal_code

      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end

      row "GST" do |order|
        "#{number_to_percentage(
          order.gst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )} — #{number_to_currency(order.gst_amount)}"
      end

      row "PST" do |order|
        "#{number_to_percentage(
          order.pst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )} — #{number_to_currency(order.pst_amount)}"
      end

      row "HST" do |order|
        "#{number_to_percentage(
          order.hst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )} — #{number_to_currency(order.hst_amount)}"
      end

      row :total do |order|
        number_to_currency(order.total)
      end
    end

    panel "Products" do
      table_for order.order_items do
        column :product_name

        column :unit_price do |item|
          number_to_currency(item.unit_price)
        end

        column :quantity

        column :line_total do |item|
          number_to_currency(item.line_total)
        end

        column "Current product" do |item|
          if item.product.present?
            link_to item.product.name,
                    admin_product_path(item.product)
          else
            status_tag "Deleted"
          end
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs "Order status" do
      f.input :status,
              as: :select,
              collection: Order::STATUSES.map {
                |status| [ status.titleize, status ]
              },
              include_blank: false
    end

    f.actions
  end

  controller do
    def scoped_collection
      super.includes(
        :customer,
        order_items: :product
      )
    end
  end
end
