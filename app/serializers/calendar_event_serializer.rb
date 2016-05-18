# Parent serializer, common fields for both objects
class CalendarEventSerializer < ApplicationSerializer
  attributes :id
  attributes :date
  attributes :time
  attributes :note

  def id
    object._id.to_s
  end
end
