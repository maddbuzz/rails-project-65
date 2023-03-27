# frozen_string_literal: true

require 'application_system_test_case'

class AdminTest < ApplicationSystemTestCase
  setup do
    @bulletin = bulletins(:draft)
    sign_in users(:system_test)
  end

  test 'admin should have access to admin panel' do
    click_on t('layouts.shared.nav.admin_panel')
    assert_selector 'h1', text: t('web.admin.home.index.ads_on_moderation')
    click_on t('layouts.admin_panel_menu.all_ads')
    assert_selector 'h2', text: t('web.admin.bulletins.index.all_bulletins')
    click_on t('layouts.admin_panel_menu.categories')
    assert_selector 'h1', text: t('web.admin.categories.index.title')
    click_on t('layouts.admin_panel_menu.users')
    assert_selector 'h1', text: t('web.admin.users.index.title')
    click_on t('layouts.admin_panel_menu.ads_on_moderation')
    assert_selector 'h1', text: t('web.admin.home.index.ads_on_moderation')
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

  test 'admin should add category' do
    click_on t('layouts.shared.nav.admin_panel')
    click_on t('layouts.admin_panel_menu.categories')
    click_on t('web.admin.categories.index.add_category')
    assert_text t('web.admin.categories.new.title')

    fill_in t('web.admin.categories.form.placeholder'), with: Faker::Lorem.sentence

    assert_difference('Category.count', +1) do
      click_on t('web.admin.categories.new.submit')
      assert_text t('web.admin.categories.create.success')
    end
  end

  test 'admin should make user admin' do
    click_on t('layouts.shared.nav.admin_panel')
    click_on t('layouts.admin_panel_menu.users')

    user = users(:one)
    assert { !user.admin? }
    find(:xpath, "//*[@href='#{edit_admin_user_path(user)}']").click
    assert_text t('web.admin.users.edit.title')

    check t('activerecord.attributes.user.admin')

    click_on t('web.admin.users.edit.submit')
    assert_text t('web.admin.users.update.success')
    assert { user.reload.admin? }
  end
end
