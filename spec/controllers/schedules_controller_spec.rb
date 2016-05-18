require 'rails_helper'
RSpec.describe SchedulesController, type: :controller do
  subject(:schedule) { FactoryGirl.create(:schedule_event) }

  describe 'GET #index' do
    it ':not_found' do
      get :index
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content['schedules'].length).to eq(0)
    end

    it ':success' do
      schedule
      get :index
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content['schedules'].length).to eq(1)
      expect(content['schedules'][0].appointmentEvents.length).to eq(3)
    end
  end

  describe 'GET #show' do
    it ':not_found' do
      get :show, id: 1
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content.errors).to eq('ScheduleEvent does not exist')
    end

    it ':success' do
      get :show, id: schedule.id
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content.scheduleEvent.date).to eq schedule.date.strftime('%Y-%m-%d')
      expect(content.scheduleEvent.endDate).to eq schedule.end_date.strftime('%Y-%m-%d')
      expect(content.scheduleEvent.time).to eq schedule.time
      expect(content.scheduleEvent.appointmentEvents.length).to eq(3)
      expect(content.scheduleEvent.appointmentEvents[0].status).to eq 'planned'
      expect(content.scheduleEvent.appointmentEvents[0].changedEvent).to be_falsy
    end
  end

  describe 'DELETE' do
    it ':not_found' do
      delete :destroy, id: 1
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content.errors).to eq('ScheduleEvent does not exist')
    end
    it ':success' do
      delete :destroy, id: schedule.id
      expect(response).to have_http_status(:success)
      expect(AppointmentEvent.all.length).to eq(1)
    end
  end

  describe 'POST #create' do
    it 'ParameterMissing' do
      expect { post :create, schedule: {} }.to raise_error ActionController::ParameterMissing
    end

    it ':bad_request' do
      post :create, schedule: { frequence: nil }
      content = json response.body

      expect(response).to have_http_status(:bad_request)

      expect(content.errors.length).to eq 5
      expect(content.errors).to include 'Date can\'t be blank'
      expect(content.errors).to include 'Time can\'t be blank'
      expect(content.errors).to include 'End date can\'t be blank'
      expect(content.errors).to include 'Frequence is not a number'
    end

    it ':bad_request' do
      post :create, schedule: { frequence: 0 }
      content = json response.body

      expect(response).to have_http_status(:bad_request)
      expect(content.errors.length).to eq 4
      expect(content.errors).to include 'Date can\'t be blank'
      expect(content.errors).to include 'Time can\'t be blank'
      expect(content.errors).to include 'End date can\'t be blank'
    end

    it ':success' do
      post :create, schedule: { end_date: 10.days.from_now,
        time: '16:00', note: 'rspec tests', date: Date.today, frequence: 2 }
      content = json response.body

      expect(response).to have_http_status :success
      expect(content.scheduleEvent.note).to eq 'rspec tests'
      expect(content.scheduleEvent.time).to eq '16:00'
      expect(content.scheduleEvent.appointmentEvents.length).to eq 5
      expect(content.scheduleEvent.appointmentEvents[0].date).to eq Date.today.strftime('%Y-%m-%d')
      expect(content.scheduleEvent.appointmentEvents[0].changedEvent).to be_falsy
    end
  end

  describe 'PUT #update' do
    it 'ParameterMissing' do
      expect { put :update, id: schedule.id, schedule: {} }.to \
        raise_error ActionController::ParameterMissing
    end

    it ':not_found user' do
      put :update, id: 1, schedule: { date: 5.days.from_now,
        time: '16:00', note: 'rspec tests' }
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content['errors']).to eq('ScheduleEvent does not exist')
    end

    it ':bad_request' do
      put :update, id: schedule.id, schedule: { note: 'changed', time: nil,
        frequence: 0 }
      content = json response.body

      expect(response).to have_http_status(:bad_request)
      expect(content.errors).to include 'Time can\'t be blank'
      expect(content.errors).to include 'Frequence must be greater than 0'
    end

    it ':success' do
      appoint = schedule.appointment_events[2]
      appoint.changed_event = true
      appoint.save!
      put :update, id: schedule.id, schedule: { note: 'success', time: '18:00' }
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content.scheduleEvent.time).to eq '18:00'
      expect(content.scheduleEvent.note).to eq 'success'
      expect(content.scheduleEvent.appointmentEvents.length).to eq 4
    end
  end
end
