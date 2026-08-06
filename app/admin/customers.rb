ActiveAdmin.register Customer do
  menu priority: 4

  actions :all,
          except: %i[new create destroy]

  permit_params :email,
                :first_name,
                :last_name,
                :phone_number,
                :address_line_1,
                :address_line_2,
                :city,
                :province_id,
                :postal_code

  config.sort_order = "created_at_desc"

  filter :first_name
  filter :last_name
  filter :email
  filter :province
  filter :city
  filter :created_at

  index do
    id_column

    column :first_name
    column :last_name
    column :email
    column :city
    column :province
    column :postal_code
    column "Orders" do |customer|
      customer.orders.count
    end
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :address_line_1
      row :address_line_2
      row :city
      row :province
      row :postal_code
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      if customer.orders.any?
        table_for customer.orders.order(placed_at: :desc) do
          column "Order" do |order|
            link_to "##{order.id}", admin_order_path(order)
          end

          column :status do |order|
            status_tag order.status
          end

          column :placed_at
          column :total do |order|
            number_to_currency(order.total)
          end
        end
      else
        para "This customer has not placed any orders."
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs "Customer details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
    end

    f.inputs "Address" do
      f.input :address_line_1
      f.input :address_line_2
      f.input :city
      f.input :province
      f.input :postal_code
    end

    f.actions
  end
end
