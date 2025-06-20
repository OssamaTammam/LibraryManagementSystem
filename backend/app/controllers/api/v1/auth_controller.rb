class Api::V1::AuthController < Api::ApiController
  skip_before_action :authenticate_request!, only: [ :login, :signup ]

  def signup
    user = User.create!(signup_params)
    render_success({ user: serializer(user) }, :created)
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      jwt = JsonWebToken.encode(user_id: user.id)
      cookies.encrypted[:jwt] = {
        value: jwt,
        httponly: true,
        same_site: :strict,
        secure: Rails.env.production?
      }
      render_success({ message: "Sign in successful", user:{
        id: user.id,
        username: user.username,
        admin: user.admin,
      } },)
    else
      render_error("Invalid email or password", :unauthorized)
    end
  end

  private

  def signup_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def login_params
    params.permit(:email, :password)
  end

  def serializer_class
    "UserSerializer".constantize
  end
end
