# Class that contains the common information for appointment and schedule
class CalendarEvent
  include Mongoid::Document
  include ActiveModel::Validations
  include SimpleEnum::Mongoid

  field :date,    type: Date
  field :time,    type: String
  field :note,    type: String

  validates_presence_of :date, :time
end
