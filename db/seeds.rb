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
Vote.delete_all

# User.delete_all
# User.create!(username: "efatsi", role: "admin", password: "secret", password_confirmation: "secret")
# User.create!(username: "amelia", role: "user", password: "secret", password_confirmation: "secret")

50.times do |article|
  if rand < 0.5
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.first.id)
  else
    Article.create!(title: Faker::Name.name, link: "github.com/efatsi/Haxxor-News/pull/4/files", user_id: User.last.id)
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

200.times do |more_comments|
  if rand < 0.5
    # comment on an article
    Comment.create!(content: "Extra comments!", commentable_id: Article.first.id + rand(Article.all.length), commentable_type: "Article", user_id: User.first.id + rand.round)
  else
    # comment on a comment
    Comment.create!(content: "Extra comment on a comment!", commentable_id: Comment.first.id + rand(Comment.all.length), commentable_type: "Comment", user_id: User.first.id + rand.round)
  end
end

Comment.all.each do |c|
  c.update_count
end

Article.all.each do |a|
  if rand < 0.5
    Vote.create!(user_id: User.first.id + rand.round, votable_type: "Article", votable_id: a.id, direction: "up")
    a.points += 1; a.save
  else
    Vote.create!(user_id: User.first.id + rand.round, votable_type: "Article", votable_id: a.id, direction: "down")
    a.points -= 1; a.save
  end    
end

Comment.all.each do |c|
  if rand < 0.5
    Vote.create!(user_id: User.first.id + rand.round, votable_type: "Comment", votable_id: c.id, direction: "up")
    c.points += 1; c.save
  else
    Vote.create!(user_id: User.first.id + rand.round, votable_type: "Comment", votable_id: c.id, direction: "down")
    c.points -= 1; c.save
  end    
end