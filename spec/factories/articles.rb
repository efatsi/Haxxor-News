FactoryGirl.define do
  factory :article do
    user
    title 'Example Article'
    link 'http://example.com'
  end
end