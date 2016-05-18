require 'rails_helper'
RSpec.describe AppointmentsController, type: :controller do
  subject(:appointment) { FactoryGirl.create(:appointment_event) }

  describe 'GET #index' do
    it ':not_found' do
      get :index
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content['appointments'].length).to eq(0)
    end

    it ':success' do
      4.times.each { |_i| FactoryGirl.create(:appointment_event) }
      get :index
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content['appointments'].length).to eq(4)
    end
  end

  describe 'GET #show' do
    it ':not_found' do
      get :show, id: 1
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content.errors).to eq('AppointmentEvent does not exist')
    end

    it ':success' do
      get :show, id: appointment.id
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content.appointmentEvent.date).to eq appointment.date.strftime('%Y-%m-%d')
      expect(content.appointmentEvent.time).to eq appointment.time
      expect(content.appointmentEvent.changedEvent).to be_truthy
      expect(content.appointmentEvent.status).to eq 'planned'
    end
  end

  describe 'DELETE' do
    it ':not_found' do
      delete :destroy, id: 1
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content.errors).to eq('AppointmentEvent does not exist')
    end
    it ':success' do
      delete :destroy, id: appointment.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'ParameterMissing' do
      expect { post :create, appointment: {} }.to raise_error ActionController::ParameterMissing
    end

    it ':bad_request' do
      post :create, appointment: { status: :completed }
      content = json response.body

      expect(response).to have_http_status(:bad_request)
      expect(content.errors.length).to eq 2
      expect(content.errors).to include 'Date can\'t be blank'
      expect(content.errors).to include 'Time can\'t be blank'
    end

    it ':success' do
      post :create, appointment: { date: 5.days.from_now,
        time: '16:00', note: 'rspec tests', status: :completed }
      content = json response.body

      expect(response).to have_http_status :success
      expect(content.appointmentEvent.note).to eq 'rspec tests'
      expect(content.appointmentEvent.time).to eq '16:00'
      expect(content.appointmentEvent.status).to eq 'completed'
      expect(content.appointmentEvent.date).to eq 5.days.from_now.strftime('%Y-%m-%d')
      expect(content.appointmentEvent.changedEvent).to be_truthy
    end
  end

  describe 'PUT #update' do
    it 'ParameterMissing' do
      expect { put :update, id: appointment.id, appointment: {} }.to \
        raise_error ActionController::ParameterMissing
    end

    it ':not_found user' do
      put :update, id: 1, appointment: { date: 5.days.from_now,
        time: '16:00', note: 'rspec tests', status: :completed }
      content = json response.body

      expect(response).to have_http_status(:not_found)
      expect(content['errors']).to eq('AppointmentEvent does not exist')
    end

    it ':bad_request' do
      put :update, id: appointment.id, appointment: { note: 'changed', time: nil }
      content = json response.body

      expect(response).to have_http_status(:bad_request)
      expect(content.errors).to include 'Time can\'t be blank'
    end

    it ':success' do
      put :update, id: appointment.id, appointment: { note: 'success', time: '18:00' }
      content = json response.body

      expect(response).to have_http_status(:success)
      expect(content.appointmentEvent.time).to eq '18:00'
      expect(content.appointmentEvent.note).to eq 'success'
    end
  end
end
