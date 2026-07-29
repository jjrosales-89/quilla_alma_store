require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "displays all product categories" do
    get categories_url

    assert_response :success
    assert_select "h1", "Product categories"
    assert_select "a", text: "Browse category", minimum: 2
    assert_select "h2", categories(:coffee).name
    assert_select "h2", categories(:textiles).name
  end

  test "displays products belonging to one category" do
    category = categories(:coffee)

    get category_url(category)

    assert_response :success

    assert_select ".breadcrumbs" do
      assert_select "a[href=?]", root_path, text: "Home"
      assert_select "a[href=?]", categories_path, text: "Categories"
      assert_select "span", text: category.name
    end

    assert_select "h1", category.name
    assert_select "a", text: products(:coffee).name
    assert_select "a", text: products(:throw).name, count: 0
  end

  test "displays breadcrumbs on the category index" do
    get categories_url

    assert_response :success

    assert_select ".breadcrumbs" do
      assert_select "a[href=?]", root_path, text: "Home"
      assert_select "span", text: "Categories"
    end
  end
end
