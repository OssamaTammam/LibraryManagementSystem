class UserSerializer < ApplicationSerializer
  attributes :id, :username, :email, :created_at, :updated_at, :admin

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def updated_at
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
