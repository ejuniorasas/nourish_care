require 'rails_helper'

RSpec.describe AppointmentEvent, type: :model do
  subject(:appointment) { FactoryGirl.create(:schedule_appointment) }

  describe 'create' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :date  }
    it { is_expected.to validate_presence_of :time  }
    it { is_expected.to belong_to :schedule_event   }
  end

  describe 'simple Appointment' do
    let(:appoint) { FactoryGirl.create(:appointment_event) }

    it 'initial status' do
      expect(appoint.status).to eq :planned
    end
  end
end
