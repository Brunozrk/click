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
end
