FactoryGirl.define do
  factory :comment do
    content "This is a comment"
    user
  end
end