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

  test "searches products by keyword" do
    get products_url(query: "Medium-roast")

    assert_response :success
    assert_select "a", text: products(:coffee).name
    assert_select "a", text: products(:throw).name, count: 0
  end

  test "filters products by category" do
    get products_url(category_id: categories(:textiles).id)

    assert_response :success
    assert_select "a", text: products(:throw).name
    assert_select "a", text: products(:coffee).name, count: 0
  end

  test "filters products that are on sale" do
    get products_url(on_sale: "1")

    assert_response :success
    assert_select "a", text: products(:throw).name
    assert_select "a", text: products(:coffee).name, count: 0
  end

  test "filters products created within the past three days" do
    products(:coffee).update_column(:created_at, 4.days.ago)
    products(:throw).update_column(:created_at, 1.day.ago)

    get products_url(new_products: "1")

    assert_response :success
    assert_select "a", text: products(:throw).name
    assert_select "a", text: products(:coffee).name, count: 0
  end

  test "paginates the product catalog" do
    7.times do |number|
      Product.create!(
        category: categories(:coffee),
        name: "Pagination Product #{number}",
        description: "Product created to test pagination.",
        price: 10.00,
        stock_quantity: 5,
        on_sale: false
      )
    end

    get products_url

    assert_response :success
    assert_select ".product-card", count: 8
    assert_select ".pagination"

    get products_url(page: 2)

    assert_response :success
    assert_select ".product-card", count: 1
  end
end
