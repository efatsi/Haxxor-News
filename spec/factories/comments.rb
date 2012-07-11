FactoryGirl.define do
  factory :comment do
    association :commentable, :factory => :article
    content "This is a comment"
    user
  end
end