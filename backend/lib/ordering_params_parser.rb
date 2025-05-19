# frozen_string_literal: true

class OrderingParamsParser
  def self.parse(param, direction)
    sanitized_direction = %w[asc desc].include?(direction.downcase) ? direction : "asc"
    ordering_attr = param.split("order_by_")[1]
    [ ordering_attr, sanitized_direction ]
  end
end
