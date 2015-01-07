FactoryGirl.define do
  factory :report, class: Report do
    first_entry '08:00'
    first_exit '12:00'
    second_entry '14:00'
    second_exit '18:00'
    day Date.today
    user User.last
  end

  factory :report_without_second_exit, class: Report do
    first_entry '08:00'
    first_exit '12:00'
    second_entry '14:30'
    day Date.today
    user User.last
  end

  days = rand(365)
  factory :repor_with_random_date, class: Report do
    first_entry '08:00'
    first_exit '12:00'
    second_entry '13:00'
    second_exit '17:00'
    day Faker::Date.backward(days)
    user User.last
  end
    
end

