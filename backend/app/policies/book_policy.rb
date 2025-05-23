class BookPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def get_borrowed_books?
    user.present?
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
    user.present?
  end

  def buy?
    user.present?
  end

  def return?
    user.present?
  end
end
