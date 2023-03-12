# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @test_i18n_path = 'web.admin.users'
        @user = users(:one)
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_users_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil

        user = users(:two)
        sign_in user
        assert_not user.admin?
        get admin_users_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil
      end

      test 'admin should get index' do
        sign_in @user_admin
        get admin_users_path
        assert_response :success
      end

      test 'admin should get edit' do
        sign_in @user_admin
        get edit_admin_user_path(@user)
        assert_response :success
      end

      test 'admin should update' do
        sign_in @user_admin
        patch admin_user_path(@user), params: { user: { email: 'balbes@gmail.com' } }
        assert_redirected_to admin_users_url
        assert_flash 'update.success'
      end

      test 'admin should destroy' do
        sign_in @user_admin
        assert_difference('User.count', -1) do
          delete admin_user_path(@user)
        end
        assert_redirected_to admin_users_url
        assert_flash 'destroy.success'
      end
    end
  end
end
