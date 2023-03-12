# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  test 'typical scenario' do
    bulletin = Bulletin.new
    assert bulletin.draft?
    bulletin.to_moderate
    assert bulletin.under_moderation?
    bulletin.reject
    assert bulletin.rejected?
    bulletin.to_moderate
    assert bulletin.may_publish?
    bulletin.publish
    assert bulletin.published?
    bulletin.archive
    assert bulletin.archived?
  end
end
