# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'new user not admin' do
    user = User.new
    assert_not user.admin?

    user.admin = true
    assert user.admin?
  end
end
