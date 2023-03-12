# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "don't save without name" do
    category = categories(:one)
    assert category.save

    category.name = ''
    assert_not category.save
  end
end
