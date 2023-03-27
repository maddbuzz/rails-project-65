# frozen_string_literal: true

require 'application_system_test_case'

class GuestTest < ApplicationSystemTestCase
  setup do
    @bulletin = bulletins(:published)
  end

  test 'should visit root' do
    visit root_path
    assert_selector 'h2', text: t('web.bulletins.index.bulletins')
  end

  test 'should click bulletin and visit show' do
    visit root_path

    # click_on @bulletin.title # DON'T WORK: Selenium::WebDriver::Error::ElementNotInteractableError: Element <a href="/bulletins/675045400"> could not be scrolled into view
    find(:xpath, "//*[@href='#{bulletin_path(@bulletin)}']", match: :first).click # WORK !!!

    assert_selector 'h2', text: @bulletin.title
    assert_text @bulletin.user.name
    assert_text @bulletin.description

    ## Selector Attribute Values
    # Several operators are supported for matching attributes:
    # name – The element must have an attribute with that name.
    # name=value – The element must have an attribute with that name and value.
    # name^=value – The attribute value must start with the specified value.
    # name$=value – The attribute value must end with the specified value.
    # name*=value – The attribute value must contain the specified value.
    # name~=word – The attribute value must contain the specified word (space separated).
    # name|=word – The attribute value must start with specified word.
    assert_selector "img[src$='#{@bulletin.image.filename}'][class*='img-thumbnail']"
  end

  test 'should not create bulletin' do
    visit new_bulletin_path
    assert_text t('user_not_authenticated')
  end

  test 'should not visit profile' do
    visit profile_path
    assert_text t('user_not_authenticated')
  end

  test 'only admin should have access to admin-panel' do
    visit admin_path
    assert_text t('user_not_admin')
    visit admin_bulletins_path
    assert_text t('user_not_admin')
    visit admin_categories_path
    assert_text t('user_not_admin')
    visit admin_users_path
    assert_text t('user_not_admin')
  end
end
