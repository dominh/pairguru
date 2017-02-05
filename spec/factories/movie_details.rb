FactoryGirl.define do
  factory :movie_details do
    poster '/vdENJAPObttowMtIwe9jgtbsEnq.jpg'
    average_rating { Faker::Number.decimal(1, 1) }
    plot_overview { Faker::Lorem.sentence(3, true) }
  end
end
