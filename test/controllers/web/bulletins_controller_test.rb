# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @test_i18n_path = 'web.bulletins'

      @bulletin = bulletins(:draft)

      @attrs = {
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        image: fixture_file_upload('food_4.jpg'),
        category_id: categories(:one).id,
        user_id: users(:one).id
      }
    end

    test 'should get root' do
      get root_path
      assert_response :success
    end

    test 'should get index' do
      get bulletins_path
      assert_response :success
    end

    test 'should get new' do
      sign_in users(:one)
      get new_bulletin_path
      assert_response :success
    end

    test 'should create bulletin' do
      sign_in users(:one)
      assert_difference('Bulletin.count') do
        post bulletins_path, params: { bulletin: @attrs }
      end
      assert_redirected_to bulletin_path(Bulletin.last)
      assert_flash 'create.success'
    end

    test 'should show bulletin' do
      get bulletin_path(@bulletin)
      assert_response :success
    end

    test 'should get edit' do
      sign_in @bulletin.user
      get edit_bulletin_path(@bulletin)
      assert_response :success
    end

    test 'should update bulletin' do
      sign_in @bulletin.user
      patch bulletin_path(@bulletin), params: { bulletin: @attrs }
      assert_redirected_to profile_path
      assert_flash 'update.success'
    end

    test 'should archive bulletin' do
      sign_in @bulletin.user
      assert { @bulletin.may_archive? }
      patch archive_bulletin_url(@bulletin)
      @bulletin.reload
      assert { @bulletin.archived? }
      assert_redirected_to profile_path
      assert_flash 'archive.success'
    end

    test 'should to_moderate bulletin' do
      sign_in @bulletin.user
      assert { @bulletin.may_to_moderate? }
      patch to_moderate_bulletin_path(@bulletin)
      @bulletin.reload
      assert { @bulletin.under_moderation? }
      assert_redirected_to profile_url
      assert_flash 'to_moderate.success'
    end
  end
end
