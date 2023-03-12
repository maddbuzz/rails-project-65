# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    test 'should be authenticated first' do
      get profile_path
      assert_response :redirect
      assert_flash 'user_not_authenticated', :alert
    end

    test 'should get index' do
      sign_in users(:one)
      get profile_path
      assert_response :success
    end
  end
end
