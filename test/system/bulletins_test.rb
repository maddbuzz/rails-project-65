# frozen_string_literal: true

require 'application_system_test_case'

class BulletinsTest < ApplicationSystemTestCase
  FIXTURE_IMAGE_FILE_PATH = 'test/fixtures/files/food_4.jpg'

  setup do
    @bulletin = bulletins(:draft)
    sign_in users(:system_test)
  end

  test 'should be on the root' do
    assert_selector 'h2', text: t('web.bulletins.index.bulletins')
  end

  test 'should log out and log in' do
    click_on t('layouts.shared.nav.log_out')
    assert_text t('web.auth.logout.signed_out')
    click_on t('layouts.shared.nav.log_in')
    assert_text t('web.auth.callback.signed_in')
  end

  test 'should create bulletin' do
    click_on t('layouts.shared.nav.new_bulletin')
    assert_selector 'h2', text: t('web.bulletins.new.title')

    fill_in t('activerecord.attributes.bulletin.title'), with: @bulletin.title
    fill_in t('activerecord.attributes.bulletin.description'), with: @bulletin.description
    select @bulletin.category.name, from: t('activerecord.attributes.bulletin.category')
    attach_file t('activerecord.attributes.bulletin.image'), FIXTURE_IMAGE_FILE_PATH

    click_on t('web.bulletins.new.submit')
    assert_text t('web.bulletins.create.success')

    assert_selector 'h2', text: @bulletin.title
    assert_text @bulletin.user.name
    assert_text @bulletin.description
  end

  test 'should visit profile and update bulletin' do
    visit profile_path
    assert_selector 'h2', text: t('web.profile.index.my_bulletins')

    click_on t('web.profile.bulletin.edit'), match: :first
    assert_selector 'h2', text: t('web.bulletins.edit.title')

    fill_in t('activerecord.attributes.bulletin.title'), with: Faker::Lorem.sentence

    click_on t('web.bulletins.edit.submit')
    assert_text t('web.bulletins.update.success')
  end

  test 'should visit profile and send to moderate' do
    visit profile_path
    click_on t('web.profile.bulletin.to_moderate')
    assert_text t('web.bulletins.to_moderate.success')
  end

  test 'should visit profile and send to archive' do
    visit profile_path
    page.accept_confirm do
      click_on t('web.profile.bulletin.archive'), match: :first
    end
    assert_text t('web.bulletins.archive.success')
  end

  test 'admin should archive' do
    visit admin_path
    assert_selector 'h1', text: t('web.admin.home.index.ads_on_moderation')
    page.accept_confirm do
      click_on t('web.admin.home.bulletin.archive'), match: :first
    end
    assert_text t('web.admin.bulletins.archive.success')

    visit admin_bulletins_path
    assert_selector 'h2', text: t('web.admin.bulletins.index.all_bulletins')
    page.accept_confirm do
      click_on t('web.admin.bulletins.bulletin.archive'), match: :first
    end
    assert_text t('web.admin.bulletins.archive.success')
  end

  test 'admin should publish' do
    visit admin_path
    page.accept_confirm do
      click_on t('web.admin.home.bulletin.publish'), match: :first
    end
    assert_text t('web.admin.bulletins.publish.success')
  end

  test 'admin should reject' do
    visit admin_path
    page.accept_confirm do
      click_on t('web.admin.home.bulletin.reject'), match: :first
    end
    assert_text t('web.admin.bulletins.reject.success')
  end
end
