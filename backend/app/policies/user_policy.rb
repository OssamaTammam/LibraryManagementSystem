class UserPolicy < ApplicationPolicy
  def me?
    user == record
  end

  def update_me?
    user == record
  end

  def delete_me?
    user == record
  end

  def get_borrowed_books?
    user == record
  end

  def get_transactions?
    user == record
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
