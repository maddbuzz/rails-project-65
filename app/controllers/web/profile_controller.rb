# frozen_string_literal: true

module Web
  class ProfileController < ApplicationController
    def index
      authenticate_user!
      @bulletins = Bulletin.where(owner_id: current_user.id).order(updated_at: :desc)
    end
  end
end
