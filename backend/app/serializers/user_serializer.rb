class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email, :created_at, :updated_at

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def updated_at
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
