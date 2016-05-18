FactoryGirl.define do
  factory :appointment_event do
    date Date.today
    sequence(:note) { |n| "Appointment event #{n}" }
    time '14:00'
    changed_event true
    status 'planned'
  end

  factory :schedule_appointment, class: AppointmentEvent do
    date Date.today
    sequence(:note) { |n| "Appointment event #{n}" }
    time '14:00'
    changed_event false
    status 'planned'
    association :schedule_event
  end
end
