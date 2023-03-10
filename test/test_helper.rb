# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    # Теперь OmniAuth в тестах не обращается к внешним источникам
    OmniAuth.config.test_mode = true

    def sign_in(user, _options = {})
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: user.email,
          name: user.name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end

def t(*args, **kwargs)
  I18n.t(*args, **kwargs)
end

def assert_flash(i18n_path, type = :notice, common_i18n_path = @test_i18n_path)
  assert_equal t("#{common_i18n_path}.#{i18n_path}"), flash[type]
end
