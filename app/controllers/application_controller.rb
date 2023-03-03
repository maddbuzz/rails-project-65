# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  # include Pundit::Authorization

  helper_method :signed_in?
end
