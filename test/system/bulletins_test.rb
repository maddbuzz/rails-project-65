# frozen_string_literal: true

require 'application_system_test_case'

class BulletinsTest < ApplicationSystemTestCase
  setup do
    # @bulletin = bulletins(:published)
    # @test_i18n_path = 'web.bulletins'

    # user_admin = users(:admin)
    # sign_in(user_admin)
  end

  # test 'visiting the index' do
  #   visit bulletins_url
  #   assert_selector 'h2', text: t('web.bulletins.index.bulletins')
  #   take_screenshot
  # end

  test 'should login' do
    visit root_path
    take_screenshot
    click_on 'Войти'
    visit profile_path
  end

  # test 'should create bulletin' do
  #   visit bulletins_url
  #   click_on 'New bulletin'

  #   fill_in 'Description', with: @bulletin.description
  #   fill_in 'Title', with: @bulletin.title
  #   click_on 'Create Bulletin'

  #   assert_text 'Bulletin was successfully created'
  #   click_on 'Back'
  # end

  # test 'should update Bulletin' do
  #   visit bulletin_url(@bulletin)
  #   click_on 'Edit this bulletin', match: :first

  #   fill_in 'Description', with: @bulletin.description
  #   fill_in 'Title', with: @bulletin.title
  #   click_on 'Update Bulletin'

  #   assert_text 'Bulletin was successfully updated'
  #   click_on 'Back'
  # end

  # test 'should destroy Bulletin' do
  #   visit bulletin_url(@bulletin)
  #   click_on 'Destroy this bulletin', match: :first

  #   assert_text 'Bulletin was successfully destroyed'
  # end
end
