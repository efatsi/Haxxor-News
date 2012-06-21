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

# User.delete_all
# User.create!(username: "efatsi", role: "admin", password: "secret", password_confirmation: "secret")
# User.create!(username: "amelia", role: "member", password: "secret", password_confirmation: "secret")

def random_date
  years_back = 3
  year = Time.now.year - (rand * (years_back)).floor
  month = (rand * 12).ceil
  day = (rand * 31).ceil
  date = Time.local(year, month, day)
  if date > Time.now
    random_date
  else
    date
  end
end

50.times do |article|
  if rand < 0.5
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.first.id, points: rand(100).to_i, created_at: random_date)
  else
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.last.id, points: rand(100).to_i, created_at: random_date)
  end    
end

Article.all.each do |a|
  if rand < 0.3
    c = Comment.create!(content: "Comment 1", commentable_id: a.id, commentable_type: "Article", user_id: User.first.id)
    Comment.create!(content: "Comment 1.1", commentable_id: c.id, commentable_type: "Comment", user_id: User.last.id)
    Comment.create!(content: "Comment 1.2", commentable_id: c.id, commentable_type: "Comment", user_id: User.last.id)
    Comment.create!(content: "Comment 1.1.1", commentable_id: (c.id + 1), commentable_type: "Comment", user_id: User.first.id)
    Comment.create!(content: "Comment 2", commentable_id: a.id, commentable_type: "Article", user_id: User.last.id)
  elsif rand < 0.8
    Comment.create!(content: "Lonely Comment", commentable_id: a.id, commentable_type: "Article", user_id: User.first.id)
    Comment.create!(content: "Lonely Comment's Buddy!", commentable_id: a.id, commentable_type: "Article", user_id: User.first.id)
  end
end

Comment.all.each do |c|
  c.update_count
end
