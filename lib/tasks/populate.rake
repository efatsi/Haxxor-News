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
    
    # Step 1a: Add Eli as admin and user
    ef = User.new
    ef.user_name = "efatsi"
    ef.role = "admin"
    ef.password = "secret"
    ef.password_confirmation = "secret"
    ef.save!
    
    # Step 4: Add some articles to the system
    Article.populate 10 do |article|
      # get some fake data using the Faker gem
      article.title = Faker::Name.name
      article.link = Faker::Internet.domain_name
      article.date = 2.years.ago..1.week.ago
      article.user_id = ef.id
      article.points = rand(100).to_i
      article.created_at = Time.now
      article.updated_at = Time.now
    end
  end
end