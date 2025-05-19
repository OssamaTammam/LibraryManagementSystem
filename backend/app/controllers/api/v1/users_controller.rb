class Api::V1::UsersController < Api::ApplicationController
  def me
    authorize @current_user, :me?
    render_success({ user: serializer(@current_user) })
  end

  def update_me
    authorize @current_user, :update_me?
    @current_user.update!(update_me_params)
    render_success({ user: serializer(@current_user) })
  end

  def delete_me
    authorize @current_user, :delete_me?
    @current_user.destroy!
    render_success({ message: "User deleted successfully" }, :no_content)
  end

  def index
    authorize User, :index?
    users = list(User)
    render_success({ users: serializer(users) })
  end

  def show
    authorize User, :show?
    user = User.find!(params[:id])
    render_success({ user: serializer(user) })
  end

  def destroy
    authorize User, :destroy?
    user = User.find!(params[:id])
    user.destroy!
    render_success({ message: "User deleted successfully" }, :no_content)
  end

  def update
    authorize User, :update?
    user = User.find!(params[:id])
    user.update!(user_params)
    render_success({ user: serializer(user) })
  end

  private

  def update_me_params
    params.permit(:username, :email)
  end

  def user_params
    params.permit(:username, :email, :admin)
  end
end
