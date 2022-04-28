class DisturbancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user
  end

  def show?
    @user
  end

  def new?
    @user.admin?
  end

  def create?
    new?
  end

  def edit?
    @user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    @user.admin?
  end
end