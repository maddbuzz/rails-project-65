# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class HomeControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert

        user = users(:one)
        sign_in user
        assert_not user.admin?
        get admin_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert
      end

      test 'admin should get index' do
        sign_in @user_admin
        get admin_path
        assert_response :success
      end
    end
  end
end
