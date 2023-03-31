# frozen_string_literal: true

require 'test_helper'

FIXTURE_IMAGE_FILE_NAME = 'food_4.jpg'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @bulletin = bulletins(:draft)

      @attrs = {
        title: bulletins(:archived).title,
        description: bulletins(:archived).description,
        category_id: categories(:two).id
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
      image = fixture_file_upload(FIXTURE_IMAGE_FILE_NAME)
      post bulletins_path, params: { bulletin: { **@attrs, image: } }
      last_bulletin = Bulletin.last
      assert_redirected_to bulletin_path(last_bulletin)
      assert_flash 'web.bulletins.create.success'
      assert { @attrs.none? { |key, value| last_bulletin[key] != value } }
      assert { image.original_filename == last_bulletin.image.filename.to_s }
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
      assert_flash 'web.bulletins.update.success'
      @bulletin.reload
      assert { @attrs.none? { |key, value| @bulletin[key] != value } }
    end

    test 'should archive bulletin' do
      sign_in @bulletin.user
      patch archive_bulletin_url(@bulletin)
      assert_redirected_to profile_path
      assert_flash 'web.bulletins.archive.success'
      assert { @bulletin.reload.archived? }
    end

    test 'should to_moderate bulletin' do
      sign_in @bulletin.user
      patch to_moderate_bulletin_path(@bulletin)
      assert_redirected_to profile_url
      assert_flash 'web.bulletins.to_moderate.success'
      assert { @bulletin.reload.under_moderation? }
    end
  end
end
