# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    # def logout
    #   sign_out
    #   redirect_to root_path
    # end

    def callback
      # debugger
      return redirect_to root_path if signed_in?

      user_info = request.env['omniauth.auth']
      email, name = user_info[:info].values_at(:email, :name)
      user = User.find_or_initialize_by(email: email.downcase)
      return redirect_to root_path, alert: t('.failure') unless user.update(name:)

      sign_in user
      redirect_to root_path, notice: t('.success')
    end
  end
end
