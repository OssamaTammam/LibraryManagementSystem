class BookPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
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

  def borrow?
    user.admin?
  end

  def buy?
    user.admin?
  end

  def return?
    user.admin?
  end
end
