# Schedule CRUD
class SchedulesController < ApplicationController
  include ActionController::Serialization
  # load_and_authorize_resource
  around_action :handle_exception

  resource_description do
    short 'Calendar event, with repetition'
    description <<-APPOIN
    Controler for create and list schedules created,
    one schedule is a Calendar event with some more
    especialization informations and actions!
    APPOIN
  end

  api!
  def index
    render json: ScheduleEvent.all
  end

  api!
  param :id, String, required: true, desc: 'An Especific schedule'
  def show
    render json: schedule_event
  end

  api!
  def create
    schedule = ScheduleEvent.new schedule_event_params
    schedule.save!
    render json: schedule
  end

  api!
  param :id, String, required: true, desc: 'Editing an especific schedule by ID'
  def update
    schedule = schedule_event
    schedule.update!(schedule_event_params)
    render json: schedule
  end

  api!
  param :id, String, required: true, desc: 'Deleting an especific schedule by ID'
  def destroy
    schedule_event.destroy!
    render nothing: true, status: :no_content
  end

  private

  def schedule_event
    @schedule ||= ScheduleEvent.find(params[:id])
  end

  def schedule_event_params
    params.require(:schedule).permit(:date, :end_date, :frequence, :time, :note)
  end
end
