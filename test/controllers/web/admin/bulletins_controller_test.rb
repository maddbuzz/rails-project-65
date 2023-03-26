# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user_admin = users(:admin)
        @bulletin = bulletins(:under_moderation)
      end

      test 'only admin should get index' do
        get admin_bulletins_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert

        user = users(:one)
        sign_in user
        assert_not user.admin?
        get admin_bulletins_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert
      end

      test 'admin should get index' do
        sign_in @user_admin
        get admin_bulletins_path
        assert_response :success
      end

      test 'should archive bulletin' do
        sign_in @user_admin
        patch archive_admin_bulletin_url(@bulletin)
        assert_response :redirect
        assert_flash 'web.admin.bulletins.archive.success'
        assert { @bulletin.reload.archived? }
      end

      test 'should publish bulletin' do
        sign_in @user_admin
        patch publish_admin_bulletin_path(@bulletin)
        assert_redirected_to admin_path
        assert_flash 'web.admin.bulletins.publish.success'
        assert { @bulletin.reload.published? }
      end

      test 'should reject bulletin' do
        sign_in @user_admin
        patch reject_admin_bulletin_path(@bulletin)
        assert_redirected_to admin_path
        assert_flash 'web.admin.bulletins.reject.success'
        assert { @bulletin.reload.rejected? }
      end
    end
  end
end
