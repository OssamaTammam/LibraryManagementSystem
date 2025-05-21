class Api::ApiController < ApplicationController
  before_action :authenticate_request!

  # Add pagination metadata
  after_action { pagy_headers_merge(@pagy) if @pagy }

  # Policies
  def pundit_user
    @current_user
  end

  # Authenticate user
  def authenticate_request!
    jwt_token = cookies.encrypted[:jwt]
    if jwt_token
      decoded_jwt = JsonWebToken.decode(jwt_token) if jwt_token
      @current_user = User.find_by(id: decoded_jwt[:user_id])
    end
    render_error("Unauthorized", :unauthorized) unless @current_user
  end

  # List and filter records
  def list(model, filtering_params: filtering_params(), multiselection_filtering_params: multiselection_filtering_params(), ordering_params: ordering_params())
    records = model.filter_by(filtering_params, multiselection_filtering_params).order_by(ordering_params)
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    records
  end

  def filtering_params
    []
  end

  def multiselection_filtering_params
    []
  end

  def ordering_params
    { order_by_created_at: :desc }
  end

  def serializer(objects, params: {}, serializer_class: serializer_class())
    serializer_class.render(objects, params)
  end

  def controller_model
    controller_name.classify.constantize
  end

  def serializer_class
    "#{controller_model}Serializer".constantize
  end
end
