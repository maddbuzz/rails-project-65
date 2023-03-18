# frozen_string_literal: true

module Web
  class ProfileController < ApplicationController
    def index
      authenticate_user!

      @q = Bulletin.by_owner(current_user).ransack(params[:q])
      @bulletins = @q.result.order(updated_at: :desc).page params[:page]
    end
  end
end
