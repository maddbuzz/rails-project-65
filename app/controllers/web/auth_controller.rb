# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      return redirect_to root_path, notice: t('.already_signed_in') if signed_in?

      user_info = request.env['omniauth.auth']
      email, name = user_info[:info].values_at(:email, :name)

      # Need this
      if Rails.env.test? && email.nil?
        email = 'system@test.com'
        name = 'System Test User'
      end
      # for system tests working!

      user = User.find_or_initialize_by(email: email.downcase)
      user.update(name:)

      sign_in user
      redirect_to root_path, notice: t('.signed_in')
    end

    def logout
      sign_out
      redirect_to root_path, notice: t('.signed_out')
    end
  end
end
