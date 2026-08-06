# Create the demo administrator used for Milestone 1.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@quillaalma.test")
admin_password = ENV.fetch("ADMIN_PASSWORD", "QuillaAlma123!")

admin = AdminUser.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.password_confirmation = admin_password
admin.save!

provinces = [
  {
    name: "Alberta",
    code: "AB",
    gst_rate: 0.05,
    pst_rate: 0,
    hst_rate: 0
  },
  {
    name: "British Columbia",
    code: "BC",
    gst_rate: 0.05,
    pst_rate: 0.07,
    hst_rate: 0
  },
  {
    name: "Manitoba",
    code: "MB",
    gst_rate: 0.05,
    pst_rate: 0.07,
    hst_rate: 0
  },
  {
    name: "New Brunswick",
    code: "NB",
    gst_rate: 0,
    pst_rate: 0,
    hst_rate: 0.15
  },
  {
    name: "Newfoundland and Labrador",
    code: "NL",
    gst_rate: 0,
    pst_rate: 0,
    hst_rate: 0.15
  },
  {
    name: "Nova Scotia",
    code: "NS",
    gst_rate: 0,
    pst_rate: 0,
    hst_rate: 0.14
  },
  {
    name: "Ontario",
    code: "ON",
    gst_rate: 0,
    pst_rate: 0,
    hst_rate: 0.13
  },
  {
    name: "Prince Edward Island",
    code: "PE",
    gst_rate: 0,
    pst_rate: 0,
    hst_rate: 0.15
  },
  {
    name: "Quebec",
    code: "QC",
    gst_rate: 0.05,
    pst_rate: 0.09975,
    hst_rate: 0
  },
  {
    name: "Saskatchewan",
    code: "SK",
    gst_rate: 0.05,
    pst_rate: 0.06,
    hst_rate: 0
  },
  {
    name: "Northwest Territories",
    code: "NT",
    gst_rate: 0.05,
    pst_rate: 0,
    hst_rate: 0
  },
  {
    name: "Nunavut",
    code: "NU",
    gst_rate: 0.05,
    pst_rate: 0,
    hst_rate: 0
  },
  {
    name: "Yukon",
    code: "YT",
    gst_rate: 0.05,
    pst_rate: 0,
    hst_rate: 0
  }
]

provinces.each do |attributes|
  province = Province.find_or_initialize_by(code: attributes[:code])
  province.assign_attributes(attributes)
  province.save!
end

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

# Creates 90 additional products across all six storefront categories.
locations = [
  "Quito",
  "Loja",
  "Cuenca",
  "Otavalo",
  "Mindo",
  "Baños",
  "Cotopaxi",
  "Chimborazo",
  "Galápagos",
  "Manabí",
  "Esmeraldas",
  "Riobamba",
  "Vilcabamba",
  "Imbabura",
  "Yasuní"
]

catalog_blueprints = {
  "Coffee" => {
    products: [
      "Cloud Forest Medium Roast",
      "Highland Espresso Beans",
      "Honey Process Coffee",
      "Volcanic Dark Roast",
      "Mountain Decaf Coffee",
      "Citrus Bloom Light Roast",
      "Cacao Finish Coffee",
      "Caramel Reserve Coffee",
      "Organic Breakfast Roast",
      "Single-Origin Coffee",
      "Washed Arabica Coffee",
      "Artisan Ground Coffee",
      "Cold Brew Coffee Blend",
      "Limited Harvest Coffee",
      "Heritage Coffee Beans"
    ],
    description: "Ecuadorian coffee with a balanced aroma and distinctive regional character.",
    base_price: 17.50,
    price_step: 0.85,
    tags: ["Fair Trade", "Coffee Lover", "Gift", "New Arrival"]
  },
  "Chocolate" => {
    products: [
      "Sea Salt Cacao Bar",
      "Dark Chocolate Truffles",
      "Cacao Caramel Bites",
      "Orange Cacao Bar",
      "Coffee Chocolate Bar",
      "Cacao Drinking Chocolate",
      "Roasted Nib Chocolate",
      "Coconut Cacao Squares",
      "Almond Dark Chocolate",
      "Cinnamon Cacao Bar",
      "Cacao Fruit Bonbons",
      "Dark Chocolate Medallions",
      "Cacao Hazelnut Bites",
      "Limited Harvest Chocolate",
      "Artisan Chocolate Selection"
    ],
    description: "Small-batch chocolate made with Ecuadorian cacao and carefully selected ingredients.",
    base_price: 8.25,
    price_step: 0.70,
    tags: ["Handmade", "Fair Trade", "Gift", "Limited Edition"]
  },
  "Textiles" => {
    products: [
      "Woven Cushion Cover",
      "Alpaca Blend Scarf",
      "Geometric Table Runner",
      "Artisan Market Tote",
      "Highland Woven Blanket",
      "Embroidered Wall Textile",
      "Traditional Pattern Shawl",
      "Handwoven Placemat Set",
      "Colourful Loom Scarf",
      "Andean Cushion Set",
      "Woven Laptop Sleeve",
      "Artisan Fabric Pouch",
      "Decorative Bed Runner",
      "Limited Weave Throw",
      "Heritage Textile Panel"
    ],
    description: "A colourful textile inspired by Ecuadorian weaving traditions and geometric patterns.",
    base_price: 29.00,
    price_step: 3.25,
    tags: ["Handmade", "Limited Edition", "Home Decor", "Gift"]
  },
  "Home Decor" => {
    products: [
      "Botanical Wall Print",
      "Hand-Painted Ceramic Vase",
      "Hummingbird Cushion",
      "Volcanic Landscape Print",
      "Artisan Candle Holder",
      "Decorative Serving Tray",
      "Ceramic Flower Pot",
      "Mountain Wall Hanging",
      "Painted Coffee Mug",
      "Geometric Art Print",
      "Handcrafted Picture Frame",
      "Decorative Storage Basket",
      "Tropical Leaf Poster",
      "Limited Edition Wall Art",
      "Artisan Table Centrepiece"
    ],
    description: "A decorative home accent influenced by Ecuadorian landscapes, plants, and artisan design.",
    base_price: 22.00,
    price_step: 2.50,
    tags: ["Home Decor", "Handmade", "Gift", "New Arrival"]
  },
  "Crafts" => {
    products: [
      "Tagua Bead Bracelet",
      "Artisan Keychain",
      "Painted Wooden Ornament",
      "Handmade Coin Purse",
      "Tagua Drop Earrings",
      "Woven Friendship Bracelet",
      "Ceramic Animal Figure",
      "Artisan Bookmark",
      "Hand-Painted Jewellery Box",
      "Tagua Pendant Necklace",
      "Miniature Woven Basket",
      "Decorative Travel Pouch",
      "Handcrafted Desk Ornament",
      "Limited Artisan Brooch",
      "Traditional Craft Collection"
    ],
    description: "A handcrafted accessory made with materials and techniques associated with Ecuadorian artisans.",
    base_price: 16.00,
    price_step: 1.90,
    tags: ["Handmade", "Fair Trade", "Gift", "Limited Edition"]
  },
  "Gift Boxes" => {
    products: [
      "Coffee and Cacao Gift Box",
      "Artisan Breakfast Box",
      "Chocolate Tasting Collection",
      "Ecuadorian Welcome Box",
      "Coffee Lover Gift Set",
      "Handmade Artisan Box",
      "Highland Comfort Collection",
      "Cacao Celebration Box",
      "Home Decor Gift Set",
      "Taste of Ecuador Box",
      "Premium Coffee Collection",
      "Artisan Discovery Set",
      "Holiday Cacao Box",
      "Limited Ecuador Collection",
      "Quilla Alma Signature Box"
    ],
    description: "A curated collection of Ecuadorian-inspired products prepared for gifting and celebrations.",
    base_price: 48.00,
    price_step: 3.50,
    tags: ["Gift", "Limited Edition", "New Arrival", "Fair Trade"]
  }
}

catalog_blueprints.each do |category_name, blueprint|
  category = Category.find_by!(name: category_name)

  blueprint[:products].each_with_index do |product_type, index|
    name = "#{locations[index]} #{product_type}"
    price = (blueprint[:base_price] + (index * blueprint[:price_step])).round(2)
    on_sale = (index % 5).zero?

    product = Product.find_or_initialize_by(name: name)

    product.assign_attributes(
      category: category,
      description: "#{product_type} inspired by #{locations[index]}, Ecuador. " \
                   "#{blueprint[:description]}",
      price: price,
      stock_quantity: 8 + ((index * 3) % 25),
      on_sale: on_sale,
      sale_price: on_sale ? (price * 0.85).round(2) : nil
    )

    product.save!

    # Rotates relevant tags while keeping repeated seeds idempotent.
    selected_tags = [
      blueprint[:tags][index % blueprint[:tags].length],
      blueprint[:tags][(index + 1) % blueprint[:tags].length]
    ]

    product.tags = Tag.where(name: selected_tags)
  end
end

raise "The catalog must contain at least 100 products." if Product.count < 100

puts "Admin users: #{AdminUser.count}"
puts "Provinces and territories: #{Province.count}"
puts "Categories: #{Category.count}"
puts "Products: #{Product.count}"
puts "Tags: #{Tag.count}"
puts "Product tags: #{ProductTag.count}"
