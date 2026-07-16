require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "displays available products on the front page" do
    get root_url

    assert_response :success
    assert_select "h1", "Craft, flavour, and tradition"
    assert_select "a", text: products(:coffee).name
    assert_select ".product-card", minimum: 2
  end

  test "displays an individual product page" do
    product = products(:throw)

    get product_url(product)

    assert_response :success
    assert_select "h1", product.name
    assert_select ".sale-price", "$42.00"
    assert_select ".tag", "Handmade"
  end
end
