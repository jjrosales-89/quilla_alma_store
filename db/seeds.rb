# Create the demo administrator used for Milestone 1.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@quillaalma.test")
admin_password = ENV.fetch("ADMIN_PASSWORD", "QuillaAlma123!")

admin = AdminUser.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.password_confirmation = admin_password
admin.save!

categories = {
  "Coffee" => "Ecuadorian-inspired whole-bean and ground coffee.",
  "Chocolate" => "Chocolate and cacao products made with Ecuadorian cacao.",
  "Textiles" => "Woven textiles inspired by Ecuadorian artisan traditions.",
  "Home Decor" => "Decorative products for warm and colourful living spaces.",
  "Crafts" => "Handmade accessories and artisan-crafted objects.",
  "Gift Boxes" => "Curated collections suitable for gifts and celebrations."
}

categories.each do |name, description|
  category = Category.find_or_initialize_by(name: name)
  category.description = description
  category.save!
end

tag_names = [
  "Handmade",
  "Fair Trade",
  "Limited Edition",
  "Gift",
  "New Arrival",
  "Coffee Lover",
  "Home Decor"
]

tag_names.each do |name|
  Tag.find_or_create_by!(name: name)
end

products = [
  {
    name: "Andean Sunrise Coffee",
    category: "Coffee",
    description: "Medium-roast Ecuadorian coffee with notes of caramel, citrus, and toasted almonds.",
    price: 18.95,
    stock_quantity: 24,
    on_sale: false,
    sale_price: nil,
    tags: ["Fair Trade", "Coffee Lover", "Gift"]
  },
  {
    name: "Loja Dark Roast Coffee",
    category: "Coffee",
    description: "A bold dark roast inspired by Loja, with cocoa, spice, and smoky finishing notes.",
    price: 19.95,
    stock_quantity: 18,
    on_sale: true,
    sale_price: 16.95,
    tags: ["Fair Trade", "Coffee Lover"]
  },
  {
    name: "Ecuadorian Cacao 70% Bar",
    category: "Chocolate",
    description: "A rich dark chocolate bar made with 70 percent Ecuadorian cacao and raw cane sugar.",
    price: 8.50,
    stock_quantity: 40,
    on_sale: false,
    sale_price: nil,
    tags: ["Handmade", "Fair Trade", "Gift"]
  },
  {
    name: "Cacao Nibs Gift Jar",
    category: "Chocolate",
    description: "Crunchy roasted cacao nibs packaged in a reusable glass jar for baking or snacking.",
    price: 12.95,
    stock_quantity: 20,
    on_sale: false,
    sale_price: nil,
    tags: ["Fair Trade", "Gift", "New Arrival"]
  },
  {
    name: "Otavalo Woven Table Runner",
    category: "Textiles",
    description: "A colourful woven table runner inspired by traditional Otavalo geometric patterns.",
    price: 54.00,
    stock_quantity: 8,
    on_sale: false,
    sale_price: nil,
    tags: ["Handmade", "Limited Edition", "Home Decor"]
  },
  {
    name: "Cotopaxi Wool Throw",
    category: "Textiles",
    description: "A warm woven throw featuring earthy colours inspired by the Cotopaxi highlands.",
    price: 89.00,
    stock_quantity: 6,
    on_sale: true,
    sale_price: 74.00,
    tags: ["Handmade", "Limited Edition", "Home Decor"]
  },
  {
    name: "Tagua Palm Seed Necklace",
    category: "Crafts",
    description: "A lightweight statement necklace made with polished tagua palm seeds in natural tones.",
    price: 32.00,
    stock_quantity: 14,
    on_sale: false,
    sale_price: nil,
    tags: ["Handmade", "Fair Trade", "Gift"]
  },
  {
    name: "Hand-Painted Hummingbird Mug",
    category: "Home Decor",
    description: "A ceramic mug decorated with a colourful hummingbird motif and painted floral details.",
    price: 28.00,
    stock_quantity: 12,
    on_sale: false,
    sale_price: nil,
    tags: ["Handmade", "Home Decor", "Gift"]
  },
  {
    name: "Quito Botanical Art Print",
    category: "Home Decor",
    description: "An archival art print featuring botanical illustrations inspired by Quito gardens.",
    price: 24.00,
    stock_quantity: 25,
    on_sale: false,
    sale_price: nil,
    tags: ["Home Decor", "Gift", "New Arrival"]
  },
  {
    name: "Ecuadorian Discovery Gift Box",
    category: "Gift Boxes",
    description: "A curated gift box containing coffee, dark chocolate, cacao nibs, and an artisan card.",
    price: 64.00,
    stock_quantity: 10,
    on_sale: false,
    sale_price: nil,
    tags: ["Gift", "Limited Edition", "Coffee Lover"]
  }
]

products.each do |attributes|
  product = Product.find_or_initialize_by(name: attributes[:name])

  product.assign_attributes(
    category: Category.find_by!(name: attributes[:category]),
    description: attributes[:description],
    price: attributes[:price],
    stock_quantity: attributes[:stock_quantity],
    on_sale: attributes[:on_sale],
    sale_price: attributes[:sale_price]
  )

  product.save!

  # Assign tags through the ProductTag join model.
  product.tags = Tag.where(name: attributes[:tags])
end

puts "Admin users: #{AdminUser.count}"
puts "Categories: #{Category.count}"
puts "Products: #{Product.count}"
puts "Tags: #{Tag.count}"
puts "Product tags: #{ProductTag.count}"
