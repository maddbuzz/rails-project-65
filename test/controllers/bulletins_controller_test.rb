# frozen_string_literal: true

require 'test_helper'

class BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @attrs = {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      image: fixture_file_upload('food_4.jpg'),
      category_id: categories(:one).id
    }
  end

  test 'should get index' do
    # get bulletins_path
    get root_path
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
  end

  test 'should show bulletin' do
    get bulletin_path(@bulletin)
    assert_response :success
  end

  test 'should get edit' do
    sign_in @bulletin.owner

    get edit_bulletin_path(@bulletin)
    assert_response :success
  end

  test 'should update bulletin' do
    sign_in @bulletin.owner

    patch bulletin_path(@bulletin), params: { bulletin: @attrs }
    # assert_redirected_to bulletin_path(@bulletin)
    assert_redirected_to profile_path
  end

  # test 'should destroy bulletin' do
  #   sign_in @bulletin.owner

  #   assert_difference('Bulletin.count', -1) do
  #     delete bulletin_path(@bulletin)
  #   end

  #   assert_redirected_to bulletins_path
  # end
end
