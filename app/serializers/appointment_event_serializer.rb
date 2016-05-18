# Serialize the JSON response of Appointment Controller
class AppointmentEventSerializer < CalendarEventSerializer
  format_keys :lower_camel
  attributes :changed_event
  attributes :status

  def schedule_event_id
    object.schedule_event_id.to_s
  end
end
