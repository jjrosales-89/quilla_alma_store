# Demo administrator account for the Quilla Alma store.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@quillaalma.test")
admin_password = ENV.fetch("ADMIN_PASSWORD", "QuillaAlma123!")

# Keep only the intended demo administrator in development.
AdminUser.where.not(email: admin_email).destroy_all

admin = AdminUser.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.password_confirmation = admin_password
admin.save!

puts "Admin user ready: #{admin.email}"
