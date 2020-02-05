class NpsSerializer < ActiveModel::Serializer
  attributes :id, :score, :touchpoint, :object_id, :object_class, :respondent_id, :respondent_class

  def object_id
    object.oid
  end
end
