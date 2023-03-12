# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @test_i18n_path = 'web.admin.bulletins'
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_bulletins_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil

        user = users(:one)
        sign_in user
        assert_not user.admin?
        get admin_bulletins_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil
      end

      test 'admin should get index' do
        sign_in @user_admin
        get admin_bulletins_path
        assert_response :success
      end

      test 'admin should get index_under_moderation' do
        sign_in @user_admin
        get admin_path
        assert_response :success
      end

      test 'should archive bulletin' do
        bulletin = bulletins(:under_moderation)
        sign_in @user_admin
        assert { bulletin.under_moderation? }
        assert { bulletin.may_archive? }
        patch archive_admin_bulletin_url(bulletin)
        assert_response :redirect
        assert_flash 'archive.success'
        # assert { bulletin.archived? }
      end

      test 'should publish bulletin' do
        bulletin = bulletins(:under_moderation)
        sign_in @user_admin
        assert { bulletin.under_moderation? }
        assert { bulletin.may_publish? }
        patch publish_admin_bulletin_path(bulletin)
        assert_redirected_to admin_path
        assert_flash 'publish.success'
        # assert { bulletin.published? }
      end

      test 'should reject bulletin' do
        bulletin = bulletins(:under_moderation)
        sign_in @user_admin
        assert { bulletin.under_moderation? }
        assert { bulletin.may_reject? }
        patch reject_admin_bulletin_path(bulletin)
        assert_redirected_to admin_path
        assert_flash 'reject.success'
        # assert { bulletin.rejected? }
      end
    end
  end
end
