ActiveAdmin.register Province do
  menu priority: 3

  permit_params :name,
                :code,
                :gst_rate,
                :pst_rate,
                :hst_rate

  config.sort_order = "name_asc"

  filter :name
  filter :code

  index do
    selectable_column
    id_column

    column :name
    column :code

    column "GST" do |province|
      number_to_percentage(
        province.gst_rate * 100,
        precision: 3,
        strip_insignificant_zeros: true
      )
    end

    column "PST" do |province|
      number_to_percentage(
        province.pst_rate * 100,
        precision: 3,
        strip_insignificant_zeros: true
      )
    end

    column "HST" do |province|
      number_to_percentage(
        province.hst_rate * 100,
        precision: 3,
        strip_insignificant_zeros: true
      )
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :code

      row "GST" do |province|
        number_to_percentage(
          province.gst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )
      end

      row "PST" do |province|
        number_to_percentage(
          province.pst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )
      end

      row "HST" do |province|
        number_to_percentage(
          province.hst_rate * 100,
          precision: 3,
          strip_insignificant_zeros: true
        )
      end

      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs "Province or territory" do
      f.input :name
      f.input :code,
              hint: "Use the two-letter abbreviation, such as MB."

      f.input :gst_rate,
              hint: "Enter 0.05 for 5%."

      f.input :pst_rate,
              hint: "Enter 0.07 for 7%."

      f.input :hst_rate,
              hint: "Enter 0.13 for 13%."
    end

    f.actions
  end
end
