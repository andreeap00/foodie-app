# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Product.destroy_all
User.destroy_all

product1 = Product.create(title: 'Pasta Carbonara', description: 'Second Courses', price: 10.99, category: 1, vegetarian: 0)
product1.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759753/foodie-app/sqxaingq4aaublpcba06', format: 'png')), filename: 'pasta_carbonara.png')

product2 = Product.create(title: 'Chicken Soup', description: 'Entrees', price: 15.99, category: 0, vegetarian: 0)
product2.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759754/foodie-app/c1vzlyvrj3jl5wfetoua', format: 'png')), filename: 'soup_chicken.png')

product3 = Product.create(title: 'Vitamin Salad', description: 'Salads', price: 20.49, category: 2, vegetarian: 1)
product3.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759754/foodie-app/w4uzrwhrd8n7szdfrovn', format: 'png')), filename: 'salad_vitamin.png')

product4 = Product.create(title: 'Pasta with Walnut', description: 'Second Courses', price: 20.99, category: 1, vegetarian: 1)
product4.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759753/foodie-app/toeiujdtyqphfiuutavq.png', format: 'png')), filename: 'pasta_walnut.png')

product5 = Product.create(title: 'Pizza Capriciosa', description: 'Second Courses', price: 35.99, category: 3, vegetarian: 0)
product5.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759753/foodie-app/gvgeerero9d3qrupg0ko', format: 'png')), filename: 'pizza_capriciosa.png')

product6 = Product.create(title: 'Pancake with Fruit', description: 'Desserts', price: 14.49, category: 4, vegetarian: 0)
product6.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759757/foodie-app/ppm1mntjlv6l0vevhjud', format: 'png')), filename: 'pancake.png')

product7 = Product.create(title: 'Caesar Salad', description: 'Salads', price: 22.99, category: 2, vegetarian: 0)
product7.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759753/foodie-app/s052okmis2k3szny4bst', format: 'png')), filename: 'salad_caesar.png')

product8 = Product.create(title: 'Green Salad', description: 'Salads', price: 19.49, category: 2, vegetarian: 1)
product8.image.attach(io: URI.open(Cloudinary::Utils.cloudinary_url('https://res.cloudinary.com/dayg0iw5i/image/upload/v1691759753/foodie-app/p6cdil23afwech55n8vo', format: 'png')), filename: 'salad_green.png')

user1 = User.create(name: 'Itachi Uchiha', email: 'itachi@railstutorial.org', role: 0, password: 'Password1!', password_confirmation: 'Password1!')
