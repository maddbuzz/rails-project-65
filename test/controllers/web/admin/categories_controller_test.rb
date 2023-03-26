# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @category = categories(:one)
        @user_admin = users(:admin)
      end

      test 'only admin should get index' do
        get admin_categories_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert

        user = users(:two)
        sign_in user
        assert_not user.admin?
        get admin_categories_path
        assert_response :redirect
        assert_flash 'user_not_admin', :alert
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
        name = Faker::Lorem.sentence
        assert_difference('Category.count', +1) do
          post admin_categories_path, params: { category: { name: } }
        end
        assert_redirected_to admin_categories_path
        assert_flash 'web.admin.categories.create.success'
        assert { { name: }.stringify_keys <= Category.last.as_json }
      end

      test 'admin should get edit' do
        sign_in @user_admin
        get edit_admin_category_path(@category)
        assert_response :success
      end

      test 'admin should update' do
        sign_in @user_admin
        name = Faker::Lorem.sentence
        patch admin_category_path(@category), params: { category: { name: } }
        assert_redirected_to admin_categories_path
        assert_flash 'web.admin.categories.update.success'
        @category.reload
        assert { { name: }.stringify_keys <= @category.as_json }
      end

      test 'admin should destroy empty' do
        sign_in @user_admin
        name = 'empty'
        assert { !Category.exists?(name:) }
        empty_category = Category.create!(name:)
        assert { Category.exists?(name:) }
        delete admin_category_path(empty_category)
        assert_redirected_to admin_categories_path
        assert_flash 'web.admin.categories.destroy.success'
        assert { !Category.exists?(name:) }
      end

      test 'cannot destroy non-empty' do
        sign_in @user_admin
        assert { Category.exists?(@category.id) }
        assert { !@category.bulletins.count.zero? }
        delete admin_category_path(@category)
        assert_redirected_to admin_categories_path
        assert_flash 'web.admin.categories.destroy.fail', :alert
        assert { Category.exists?(@category.id) }
      end
    end
  end
end
