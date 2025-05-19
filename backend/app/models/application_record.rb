class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :filter_by, lambda { |filtering_params, multiselection_filtering_params|
    obj = self
    filtering_params.each do |key, value|
      obj = obj.send("filter_by_#{key}", value) if value.present?
    end

    multiselection_filtering_params.each do |key, value|
      obj = obj.send("filter_by_#{key}", value.split(",")) if value.present? || value == false
    end
    obj
  }

  scope :order_by, lambda { |ordering_params|
    obj = self
    ordering_params.each do |param, direction|
      ordering_attr, sanitized_direction = OrderingParamsParser.parse(param.to_s, direction.to_s)
      obj = obj.order("#{table_name}.#{ordering_attr} #{sanitized_direction}") if column_names.include?(ordering_attr)
    end
    obj
  }
end
