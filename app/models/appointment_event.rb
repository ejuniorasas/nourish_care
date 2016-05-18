# Class to create a simple appointment
class AppointmentEvent < CalendarEvent
  field :changed_event, type: Boolean
  as_enum :status, %i(planned completed), source: :status

  belongs_to :schedule_event
  validates_presence_of :status
end
