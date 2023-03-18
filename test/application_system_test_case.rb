# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :firefox
  driven_by :selenium, using: :headless_firefox
  # (need to install Firefox first: sudo apt install firefox)
end
