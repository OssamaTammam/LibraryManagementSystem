# frozen_string_literal: true

class ApplicationSerializer < Oj::Serializer
  sort_attributes_by :name
  object_as :object
end
