# Appointment CRUD - one visa needs to be associeted to passport
class AppointmentsController < ApplicationController
  include ActionController::Serialization
  # load_and_authorize_resource
  around_action :handle_exception

  resource_description do
    short 'Calendar event, without repetition'
    description <<-APPOIN
    Controler for create and list appointments created,
    one appointment is a Calendar event with some more
    especialization informations!
    APPOIN
  end

  api!
  def index
    render json: AppointmentEvent.all
  end

  api!
  param :id, String, required: true, desc: 'An Especific Appointment'
  def show
    render json: appointment_event
  end

  api!
  def create
    appointment = AppointmentEvent.new appointment_event_params
    appointment.changed_event = true
    appointment.save!
    render json: appointment
  end

  api!
  param :id, String, required: true, desc: 'Editing an especific Appointment by ID'
  def update
    appointment = appointment_event
    appointment.changed_event = true
    appointment.update!(appointment_event_params)
    render json: appointment
  end

  api!
  param :id, String, required: true, desc: 'Deleting an especific Appointment by ID'
  def destroy
    appointment_event.destroy!
    render nothing: true, status: :no_content
  end

  private

  def appointment_event
    @appointment ||= AppointmentEvent.find(params[:id])
  end

  def appointment_event_params
    params.require(:appointment).permit(:date, :time, :note, :status)
  end
end
