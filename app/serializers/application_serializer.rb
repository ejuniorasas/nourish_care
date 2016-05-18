# Generic Serializer
class ApplicationSerializer < ActiveModel::Serializer
  attributes :id

  def id
    object._id.to_s
  end
end
