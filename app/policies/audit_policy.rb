class AuditPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.admin?
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def create?
    index?
  end

  def edit?
    update?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end
end
