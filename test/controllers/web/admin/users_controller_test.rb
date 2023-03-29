# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_users_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert

        sign_in @user
        assert_not @user.admin?
        get admin_users_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert
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

      test 'admin should make user admin' do
        sign_in @user_admin
        assert { !@user.admin? }
        patch admin_user_path(@user), params: { user: { admin: true } }
        assert_redirected_to admin_users_path
        assert_flash 'web.admin.users.update.success'
        assert { @user.reload.admin? }
      end

      test 'admin should destroy user with all dependent bulletins' do
        sign_in @user_admin
        assert { User.exists?(@user.id) }
        user_bulletins_count = @user.bulletins.count
        assert { !user_bulletins_count.zero? }
        assert_difference('Bulletin.count', -user_bulletins_count) do
          delete admin_user_path(@user)
        end
        assert_redirected_to admin_users_path
        assert_flash 'web.admin.users.destroy.success'
        assert { !User.exists?(@user.id) }
      end
    end
  end
end
