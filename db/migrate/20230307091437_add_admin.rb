# frozen_string_literal: true

class AddAdmin < ActiveRecord::Migration[7.0]
  def change
    User.find_by(email: 'maddbuzz@gmail.com')&.update(admin: true)
  end
end
