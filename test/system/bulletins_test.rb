# frozen_string_literal: true

require 'application_system_test_case'

FIXTURE_IMAGE_FILE_PATH = 'test/fixtures/files/food_4.jpg'

# rubocop:disable Metrics/ClassLength
class BulletinsTest < ApplicationSystemTestCase
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

  test 'should show bulletin' do
    visit bulletin_path(@bulletin)
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

  test 'should create bulletin' do
    click_on t('layouts.shared.nav.new_bulletin')
    assert_selector 'h2', text: t('web.bulletins.new.title')

    fill_in t('activerecord.attributes.bulletin.title'), with: @bulletin.title
    fill_in t('activerecord.attributes.bulletin.description'), with: @bulletin.description
    select @bulletin.category.name, from: t('activerecord.attributes.bulletin.category')
    attach_file t('activerecord.attributes.bulletin.image'), FIXTURE_IMAGE_FILE_PATH

    assert_difference('Bulletin.count', +1) do
      click_on t('web.bulletins.new.submit')
      assert_text t('web.bulletins.create.success')
    end

    last_bulletin = Bulletin.last
    assert { last_bulletin.title == @bulletin.title }
    assert { last_bulletin.description == @bulletin.description }
    assert { last_bulletin.category == @bulletin.category }
    assert { last_bulletin.image.filename == File.basename(FIXTURE_IMAGE_FILE_PATH) }
  end

  test 'should visit profile and update bulletin' do
    click_on t('layouts.shared.nav.my_bulletins')
    assert_selector 'h2', text: t('web.profile.index.my_bulletins')

    click_on t('web.profile.bulletin.edit'), match: :first
    assert_selector 'h2', text: t('web.bulletins.edit.title')

    new_title = Faker::Lorem.sentence.slice(...50)
    new_description = Faker::Lorem.paragraph.slice(...1000)
    fill_in t('activerecord.attributes.bulletin.title'), with: new_title
    fill_in t('activerecord.attributes.bulletin.description'), with: new_description

    assert { !Bulletin.exists?(title: new_title, description: new_description) }
    click_on t('web.bulletins.edit.submit')
    assert_text t('web.bulletins.update.success')
    assert { Bulletin.exists?(title: new_title, description: new_description) }
  end

  test 'should visit profile and send to moderate' do
    click_on t('layouts.shared.nav.my_bulletins')
    assert_difference('Bulletin.under_moderation.count', +1) do
      click_on t('web.profile.bulletin.to_moderate'), match: :first
      assert_text t('web.bulletins.to_moderate.success')
    end
  end

  test 'should visit profile and send to archive' do
    click_on t('layouts.shared.nav.my_bulletins')
    assert_difference('Bulletin.archived.count', +1) do
      page.accept_confirm do
        click_on t('web.profile.bulletin.archive'), match: :first
      end
      assert_text t('web.bulletins.archive.success')
    end
  end

  test 'only admin should have access to admin-panel' do
    click_on t('layouts.shared.nav.admin_panel')
    assert_selector 'h1', text: t('web.admin.home.index.ads_on_moderation')
    click_on t('layouts.admin_panel_menu.all_ads')
    assert_selector 'h2', text: t('web.admin.bulletins.index.all_bulletins')
    click_on t('layouts.admin_panel_menu.categories')
    assert_selector 'h1', text: t('web.admin.categories.index.title')
    click_on t('layouts.admin_panel_menu.users')
    assert_selector 'h1', text: t('web.admin.users.index.title')

    click_on t('layouts.shared.nav.log_out')
    sign_in(users(:one))
    assert_text t('web.auth.callback.signed_in')

    click_on t('layouts.shared.nav.admin_panel')
    assert_text t('user_not_admin')
    visit admin_bulletins_path
    assert_text t('user_not_admin')
    visit admin_categories_path
    assert_text t('user_not_admin')
    visit admin_users_path
    assert_text t('user_not_admin')
  end

  test 'admin should archive' do
    click_on t('layouts.shared.nav.admin_panel')
    assert_difference('Bulletin.archived.count', +2) do
      page.accept_confirm do
        click_on t('web.admin.home.bulletin.archive'), match: :first
      end
      assert_text t('web.admin.bulletins.archive.success')

      click_on t('layouts.admin_panel_menu.all_ads')
      page.accept_confirm do
        click_on t('web.admin.bulletins.bulletin.archive'), match: :first
      end
      assert_text t('web.admin.bulletins.archive.success')
    end
  end

  test 'admin should publish' do
    click_on t('layouts.shared.nav.admin_panel')
    assert_difference('Bulletin.published.count', +1) do
      page.accept_confirm do
        click_on t('web.admin.home.bulletin.publish'), match: :first
      end
      assert_text t('web.admin.bulletins.publish.success')
    end
  end

  test 'admin should reject' do
    click_on t('layouts.shared.nav.admin_panel')
    assert_difference('Bulletin.rejected.count', +1) do
      page.accept_confirm do
        click_on t('web.admin.home.bulletin.reject'), match: :first
      end
      assert_text t('web.admin.bulletins.reject.success')
    end
  end
end
# rubocop:enable Metrics/ClassLength
