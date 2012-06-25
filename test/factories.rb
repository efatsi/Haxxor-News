# FactoryGirl.define do
#   
#   # Prof H's factories
#   factory :store do
#     name "CMU"
#     street "5001 Forbes Avenue"
#     city "Pittsburgh"
#     state "PA"
#     zip "15213"
#     phone { rand(10 ** 10).to_s.rjust(10,'0') }
#     active true
#   end
#   
#   factory :employee do
#     first_name "Ed"
#     last_name "Gruberman"
#     email "employee@example.com"
#     password "secret"
#     password_confirmation "secret"
#     ssn { rand(9 ** 9).to_s.rjust(9,'0') }
#     date_of_birth 19.years.ago.to_date
#     phone { rand(10 ** 10).to_s.rjust(10,'0') }
#     role "employee"
#     active true
#   end
#   
#   factory :assignment do
#     association :store
#     association :employee
#     start_date 1.year.ago.to_date
#     end_date 1.month.ago.to_date
#     pay_level 1
#   end
#   
#   # My other factories
#   factory :shift do 
#     start_time "4:00pm"
#     end_time "8:00pm"
#     date Date.today
#   end
#   
#   factory :job do 
#     name "Clean Sink"
#     description "Clean that sink with a lot of effort!"
#     active true
#   end
#     
#   factory :shift_job do 
#     association :shift
#     association :job
#   end
# end
