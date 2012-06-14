# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Docs at: http://faker.rubyforge.org/rdoc/
require 'faker'

User.delete_all
Article.delete_all

User.create!(id: 1, username: "efatsi", role: "admin", password: "secret", password_confirmation: "secret")
User.create!(id: 2, username: "afatsi", role: "user", password: "secret", password_confirmation: "secret")

50.times do |article|
  Article.create!(title: Faker::Name.name, link: Faker::Internet.domain_name, user_id: 1, points: rand(100).to_i)
end