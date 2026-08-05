# Quilla Alma Store

Quilla Alma Store is a Ruby on Rails e-commerce application featuring Ecuadorian-inspired products, including coffee, chocolate, textiles, crafts, home décor, and gift boxes.

The application includes a public product catalogue, administrator management tools, product filtering, image uploads, breadcrumbs, and a session-based shopping cart.

## Features

### Public Catalogue

* Browse available products
* View individual product details
* Search by product name or description
* Filter products by category
* Filter products by tag
* Filter products that are on sale
* Filter recently added products
* Navigate results using pagination
* View breadcrumb navigation between categories and products
* View regular and sale prices

### Shopping Cart

* Add products to the cart
* Update product quantities
* Remove individual products
* Calculate item subtotals
* Calculate the total cart price
* Use the sale price when a product is on sale
* Store cart information in the Rails session

### Administrator Dashboard

* Secure administrator authentication with Devise
* Product management through ActiveAdmin
* Category management
* Tag management
* Product image uploads
* Product thumbnail previews
* Product inventory and pricing management
* Sale status and sale-price management

### Validation and Testing

* Product model validations
* Image type and size validation
* Controller tests for products, categories, and the shopping cart
* Rails autoloading verification with Zeitwerk

## Technologies

* Ruby 3.1.2
* Ruby on Rails 7.2.3.1
* SQLite
* ActiveRecord
* ActiveAdmin
* Devise
* Active Storage
* Kaminari
* Minitest
* HTML
* CSS
* JavaScript

## Data Model

The application uses the following main relationships:

* A category has many products.
* A product belongs to one category.
* A product has many tags through product tags.
* A tag has many products through product tags.
* Product tags form the join table between products and tags.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/jjrosales-89/quilla_alma_store.git
cd quilla_alma_store
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Prepare the database

```bash
bin/rails db:prepare
```

### 4. Seed the database

```bash
bin/rails db:seed
```

### 5. Start the Rails server

```bash
bin/rails server
```

Open the application in a browser:

```text
http://localhost:3000
```

## Seed Data

The seed file generates sample data for development and demonstration purposes, including:

* 1 administrator account
* 100 products
* 6 categories
* 7 tags
* Product-tag relationships

Running the seed file again may reset or recreate development data depending on the current seed configuration.

## Administrator Access

Open the administrator dashboard at:

```text
http://localhost:3000/admin
```

Default development credentials:

```text
Email: admin@quillaalma.test
Password: QuillaAlma123!
```

These credentials are intended only for local development and coursework demonstrations. They should not be used in a production environment.

Custom administrator credentials can be supplied when running the seed file:

```bash
ADMIN_EMAIL="your-email@example.com" \
ADMIN_PASSWORD="your-secure-password" \
bin/rails db:seed
```

## Product Images

Product images are managed with Active Storage.

Accepted formats:

* JPEG
* PNG
* WebP

Maximum file size:

```text
5 MB
```

Images that do not meet these validation requirements will not be accepted.

## Running Tests

Run the complete automated test suite:

```bash
bin/rails test
```

Run the Rails autoloading check:

```bash
bin/rails zeitwerk:check
```

Check for whitespace and formatting errors in Git changes:

```bash
git diff --check
```

Check the current Git repository status:

```bash
git status
```

## Project Structure

Important application directories include:

```text
app/controllers    Request handling and application logic
app/models         ActiveRecord models and validations
app/views          Public catalogue and cart views
app/admin          ActiveAdmin resource configuration
config/routes.rb   Application routes
db/seeds.rb        Development seed data
test/controllers   Controller tests
```

## Security Notes

The repository should not include sensitive local files such as:

```text
.env
config/master.key
config/credentials/*.key
db/*.sqlite3
storage/
log/
tmp/
```

The encrypted `config/credentials.yml.enc` file may remain in the repository, but its corresponding key must remain private.

## Author

Juan Jose Rosales
Full Stack Web Development
RRC Polytech
WEBD-3011 — Agile Full Stack Web Development
