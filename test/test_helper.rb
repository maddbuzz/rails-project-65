# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'capybara/rails'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    if ENV['COVERAGE']
      parallelize_setup do |worker|
        SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      end

      parallelize_teardown do |_worker|
        SimpleCov.result
      end
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

def t(*args, **kwargs)
  I18n.t(*args, **kwargs)
end

def assert_flash(i18n_path, type = :notice)
  assert_equal t(i18n_path), flash[type]
end

# Теперь OmniAuth в тестах не обращается к внешним источникам
OmniAuth.config.test_mode = true

def mock_omni_auth(user, provider = :github)
  auth_hash = {
    provider: provider.to_s,
    uid: '12345',
    info: {
      email: user.email,
      name: user.name
    }
  }
  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user, _options = {})
      mock_omni_auth(user)
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
