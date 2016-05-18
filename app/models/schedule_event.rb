# Class to control event's schedule
class ScheduleEvent < CalendarEvent
  field :end_date, type: Date
  field :frequence, type: Integer, default: 1

  has_many :appointment_events

  validates_presence_of :end_date, :frequence
  validates_numericality_of :frequence, greater_than: 0

  after_save :create_appointment!

  before_destroy :remove_relationship!

  private

  def create_appointment!
    AppointmentEvent.where(schedule_event_id: _id,
                           changed_event:     false).delete

    appointment_date = date
    while appointment_date < end_date
      AppointmentEvent.new(date: appointment_date, time: time,
                           note: note, changed_event: false, status: :planned,
                           schedule_event_id: _id).save!
      appointment_date = appointment_date.next_day frequence
    end
  end

  def remove_relationship!
    AppointmentEvent.where(schedule_event_id: _id,
                           :date.lt => Date.today).update_all(schedule_event_id: nil)
    AppointmentEvent.where(schedule_event_id: _id).delete
  end
end
