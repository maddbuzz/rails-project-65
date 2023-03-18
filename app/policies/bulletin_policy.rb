# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user
  end

  def new?
    create?
  end

  def update?
    user == record.user
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def archive?
    update? || user.admin?
  end

  def to_moderate?
    update?
  end

  def reject?
    user.admin?
  end

  def publish?
    user.admin?
  end
end
