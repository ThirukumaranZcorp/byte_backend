# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# User.find_or_create_by!(email: "admin@yopmail.com") do |user|
#     user.password = "byte@1234"
#     user.password_confirmation = "byte@1234"
#     user.role = 1
#     user.name = "byteAdmin"
# end

# Dashbord.find_or_create_by!(fee: 3.0 , min: 3.0 ,max: 5.0, users_id: 2)
# Dashbord.find_or_create_by!(fee: 3.0)

User.find_each do |user|
  Dashbord.find_or_create_by!(user_id: user.id) do |dashboard|
    dashboard.fee = 3.0
    dashboard.min = 3.0
    dashboard.max = 5.0
  end
end

