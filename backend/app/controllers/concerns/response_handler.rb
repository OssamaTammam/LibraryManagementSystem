# frozen_string_literal: true

module ResponseHandler
  extend ActiveSupport::Concern

  def render_success(objects, status_code = :ok)
    render(
      json: { success: true }.merge(objects.symbolize_keys),
      status: status_code
    )
  end

  def render_error(message, status_code)
    render(
      json: {
        success: false,
        message: message
      },
      status: status_code
    )
  end
end
