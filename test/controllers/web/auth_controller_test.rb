# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @test_i18n_path = 'web.auth'
    end

    test 'check github auth' do
      post auth_request_path('github')
      assert_response :redirect
    end

    test 'create, callback and logout' do
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.first_name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')
      assert_response :redirect
      assert_flash 'callback.signed_in'

      user = User.find_by!(email: auth_hash[:info][:email].downcase)

      assert user
      assert signed_in?

      delete auth_logout_url
      assert_response :redirect
      assert_flash 'logout.signed_out'
      assert_not signed_in?
    end
  end
end
