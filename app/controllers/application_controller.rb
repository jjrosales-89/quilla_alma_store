class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters,
                if: :devise_controller?

  helper_method :cart_item_count

  protected

    def configure_permitted_parameters
      customer_fields = [
        :first_name,
        :last_name,
        :address_line_1,
        :address_line_2,
        :city,
        :postal_code,
        :phone_number,
        :province_id
      ]

      devise_parameter_sanitizer.permit(
        :sign_up,
        keys: customer_fields
      )

      devise_parameter_sanitizer.permit(
        :account_update,
        keys: customer_fields
      )
    end

  private

    def cart
      session[:cart] ||= {}
    end

    def cart_item_count
      cart.values.sum { |quantity| quantity.to_i }
    end
end
