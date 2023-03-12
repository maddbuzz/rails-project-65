# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @test_i18n_path = 'web.bulletins'
      @bulletin = bulletins(:published)
      @attrs = {
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        image: fixture_file_upload('food_4.jpg'),
        category_id: categories(:one).id
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
      # assert_redirected_to bulletin_path(@bulletin)
      assert_redirected_to profile_path
      assert_flash 'update.success'
    end

    # test 'should destroy bulletin' do
    #   sign_in @bulletin.user
    #   assert_difference('Bulletin.count', -1) do
    #     delete bulletin_path(@bulletin)
    #   end
    #   assert_redirected_to bulletins_path
    # end

    test 'should archive bulletin' do
      bulletin = bulletins(:published)
      sign_in bulletin.user
      assert { signed_in? }
      assert { bulletin.published? }
      assert { bulletin.may_archive? }
      patch archive_bulletin_url(bulletin)
      # bulletin.reload
      assert_redirected_to profile_path
      assert_flash 'archive.success'
      # assert { bulletin.archived? }
    end

    test 'should to_moderate bulletin' do
      bulletin = bulletins(:draft)
      sign_in bulletin.user
      assert { signed_in? }
      assert { bulletin.draft? }
      assert { bulletin.may_to_moderate? }
      patch to_moderate_bulletin_path(bulletin)
      assert_redirected_to profile_url
      assert_flash 'to_moderate.success'
      # assert { bulletin.under_moderation? }
      # assert { Bulletin.find_by(id: bulletin.id).under_moderation? }
    end
  end
end
