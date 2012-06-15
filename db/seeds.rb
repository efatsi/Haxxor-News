# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Docs at: http://faker.rubyforge.org/rdoc/
require 'faker'


Article.delete_all
Comment.delete_all

User.create!(username: "efatsi", role: "admin", password: "secret", password_confirmation: "secret")
User.create!(username: "amelia", role: "user", password: "secret", password_confirmation: "secret")

50.times do |article|
  if rand < 0.5
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.first.id, points: rand(100).to_i)
  else
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.last.id, points: rand(100).to_i)
  end    
end

Comment.create!(content: "Comment 1", commentable_id: Article.first.id, commentable_type: "Article", user_id: User.first.id)
Comment.create!(content: "Comment 1.1", commentable_id: Comment.first.id, commentable_type: "Comment", user_id: User.first.id)
Comment.create!(content: "Comment 1.2", commentable_id: Comment.first.id, commentable_type: "Comment", user_id: User.last.id)
Comment.create!(content: "Comment 1.1.1", commentable_id: (Comment.first.id + 1), commentable_type: "Comment", user_id: User.first.id)
Comment.create!(content: "Comment 2", commentable_id: Article.first.id, commentable_type: "Article", user_id: User.last.id)