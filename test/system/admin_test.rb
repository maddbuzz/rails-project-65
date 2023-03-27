# frozen_string_literal: true

require 'application_system_test_case'

class AdminTest < ApplicationSystemTestCase
  setup do
    @bulletin = bulletins(:draft)
    sign_in users(:system_test)
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
end
