class ApplicationController < ActionController::API
  include ResponseHandler
  include ErrorHandler
  include Pundit::Authorization
  include Pagy::Backend
  include ActionController::Cookies
  include UserEventProducer
end
