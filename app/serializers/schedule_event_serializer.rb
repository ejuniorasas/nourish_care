# Serialize the JSON response of ScheduleEvent Controller
class ScheduleEventSerializer < CalendarEventSerializer
  format_keys :lower_camel
  attributes :end_date
  attributes :frequence

  has_many :appointment_events, serializer: AppointmentEventSerializer
end
