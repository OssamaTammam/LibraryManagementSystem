# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  ################### Custom Error Subclasses ####################
  class AuthenticationError < StandardError; end
  class AuthorizationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class TokenExpired < StandardError; end
  class InvalidRefreshToken < StandardError; end
  class RefreshTokenExpired < StandardError; end
  class GeneralRequestError < StandardError; end

  included do
    ####################### Custom Handlers ######################
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ErrorHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ErrorHandler::AuthorizationError, with: :forbidden_request
    rescue_from ErrorHandler::MissingToken, with: :unauthorized_request
    rescue_from ErrorHandler::InvalidToken, with: :unauthorized_request
    rescue_from ErrorHandler::TokenExpired, with: :unauthorized_request
    rescue_from ErrorHandler::GeneralRequestError, with: :general_bad_request
    rescue_from ArgumentError, with: :general_bad_request
    rescue_from ActiveModel::StrictValidationFailed, with: :general_bad_request
    rescue_from ActionController::ParameterMissing, with: :general_bad_request
    rescue_from JWT::ExpiredSignature, JWT::DecodeError, with: :unauthorized_request

    rescue_from ActiveRecord::RecordNotDestroyed do |err|
      render(
        json: { success: false, message: err.record.errors.full_messages.join(" ") },
        status: :bad_request
      )
    end

    # Catch record not found exception
    rescue_from ActiveRecord::RecordNotFound do |err|
      model_name = err.model.underscore.humanize
      message = if err.id
                  "#{model_name} with ID #{err.id} could not be found"
      else
                  "#{model_name} could not be found"
      end

      render(
        json: { success: false, message: message },
        status: :not_found
      )
    end

    # Catch invalid foreign key exception
    rescue_from ActiveRecord::InvalidForeignKey do |_err|
      render(
        json: { success: false, message: "Invalid ID reference. This record is referenced by other records and cannot be modified." },
        status: :not_found
      )
    end

    # Catch database exceptions
    rescue_from ActiveRecord::StatementInvalid do |err|
      render(
        json: { success: false, message: "Database error: #{err.message}" },
        status: :bad_request
      )
    end

    # Catch pagination key exception
    rescue_from Pagy::VariableError do |_err|
      render(
        json: { success: false, message: "Invalid pagination parameters" },
        status: :not_found
      )
    end

    # JSON response with message; Status code 401 - Unauthorized
    rescue_from Pundit::NotAuthorizedError do |err|
      message = err.policy.policy_error_message if err&.policy&.policy_error_message
      message = "You are not authorized to perform this action" if message.nil? || message.empty?
      render(
        json: { success: false, message: message },
        status: :forbidden
      )
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def unprocessable_entity(err)
    render(
      json: { success: false, message: err.message },
      status: :unprocessable_entity
    )
  end

  # JSON response with message: Status code 400 - any generic error code
  def general_bad_request(err)
    render(
      json: { success: false, message: err.message },
      status: :bad_request
    )
  end

  # JSON response with message; Status code 401 - Unauthorized
  def remove_cookie_unauthorized_request(err)
    delete_refresh_token_cookie
    unauthorized_request(err)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(err)
    render(
      json: { success: false, message: err.message },
      status: :unauthorized
    )
  end

  # JSON response with message; Status code 403 - Forbidden
  def forbidden_request(err)
    render(
      json: { success: false, message: err.message },
      status: :forbidden
    )
  end
end
