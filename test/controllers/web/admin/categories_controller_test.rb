# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @test_i18n_path = 'web.admin.categories'
        @category = categories(:one)
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_categories_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil

        user = users(:two)
        sign_in user
        assert_not user.admin?
        get admin_categories_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert, nil
      end

      test 'admin should get index' do
        sign_in @user_admin
        get admin_categories_path
        assert_response :success
      end

      test 'admin should get new' do
        sign_in @user_admin
        get new_admin_category_path
        assert_response :success
      end

      test 'admin should create' do
        sign_in @user_admin
        assert_difference('Category.count') do
          post admin_categories_path, params: { category: { name: 'Drugs' } }
        end
        assert_redirected_to admin_categories_url
        assert_flash 'create.success'
      end

      test 'admin should get edit' do
        sign_in @user_admin
        get edit_admin_category_path(@category)
        assert_response :success
      end

      test 'admin should update' do
        sign_in @user_admin
        patch admin_category_path(@category), params: { category: { name: 'Weapons' } }
        assert_redirected_to admin_categories_url
        assert_flash 'update.success'
      end

      test 'admin should destroy empty' do
        sign_in @user_admin
        empty_category = Category.create!(name: 'empty')
        # assert { empty_category.bulletins.count.zero? }
        assert_difference('Category.count', -1) do
          delete admin_category_path(empty_category)
        end
        assert_redirected_to admin_categories_url
        assert_flash 'destroy.success'
      end

      test 'cannot destroy non-empty' do
        sign_in @user_admin
        assert_not @category.bulletins.count.zero?
        assert_difference('Category.count', 0) do
          delete admin_category_path(@category)
        end
        assert_redirected_to admin_categories_url
        assert_flash 'destroy.fail', :alert
      end
    end
  end
end
