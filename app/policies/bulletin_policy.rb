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
    user == record.owner
  end

  def edit?
    update?
  end

  def destroy?
    user == record.owner
  end
end
