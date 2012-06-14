namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Invoke rake db:migrate just in case...
    Rake::Task['db:migrate'].invoke
    
    # Need two gems to make this work: faker & populator
    # Docs at: http://populator.rubyforge.org/
    require 'populator'
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    
    # Step 0: clear any old data in the db
    [User, Article].each(&:delete_all)
    
    # Step 1: Add Eli as admin and user
    ef = User.new
    ef.username = "efatsi"
    ef.role = "admin"
    ef.password = "secret"
    ef.password_confirmation = "secret"
    ef.save!
    
    # Step 2: Add Amelia as user
    af = User.new
    af.username = "afatsi"
    af.role = "user"
    af.password = "secret"
    af.password_confirmation = "secret"
    af.save!
    
    # Step 4: Add some articles to the system
    Article.populate 50 do |article|
      # get some fake data using the Faker gem
      article.title = Faker::Name.name
      article.link = Faker::Internet.domain_name
      article.user_id = ef.id
      article.points = rand(100).to_i
      article.created_at = Time.now
      article.updated_at = Time.now
    end
  end
end