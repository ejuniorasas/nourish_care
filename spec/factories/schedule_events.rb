FactoryGirl.define do
  factory :schedule_event do
    date 1.day.ago
    sequence(:note) { |n| "Schedule event #{n}" }
    time '14:00'
    end_date 10.day.from_now
    frequence 5

    transient do
      appointment_count 0
    end

    after(:create) do |schedule_e, evaluator|
      create_list(:schedule_appointment, evaluator.appointment_count, schedule_event: schedule_e)
    end
  end
end
