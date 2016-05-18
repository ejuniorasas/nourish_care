require 'rails_helper'

RSpec.describe AppointmentEvent, type: :model do
  subject(:appointment) { FactoryGirl.create(:schedule_event) }

  describe 'create' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :date      }
    it { is_expected.to validate_presence_of :time      }
    it { is_expected.to validate_presence_of :end_date  }
    it { is_expected.to validate_presence_of :frequence }
  end

  describe 'Appointments' do
    it '5 as frequence' do
      expect(appointment.appointment_events.length).to eq 3
    end

    it 'changing appointment' do
      past_event = appointment.appointment_events[0]
      past_event.changed_event = true
      past_event.time = '18:00'
      past_event.save!
      appointment.frequence = 1
      appointment.date = Date.today
      appointment.save!
      expect(past_event.reload.time).to eq '18:00'
      expect(appointment.reload.appointment_events.length).to eq 11
    end

    it 'delete' do
      past_event = appointment.appointment_events[0]
      past_event.changed_event = true
      past_event.time = '18:00'
      past_event.save!
      appointment.frequence = 1
      appointment.date = Date.today
      appointment.save!
      expect(past_event.reload.time).to eq '18:00'
      expect(appointment.reload.appointment_events.length).to eq 11
    end
  end
end
