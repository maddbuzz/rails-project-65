# frozen_string_literal: true

class AddAdmin < ActiveRecord::Migration[7.0]
  def change
    # User.find_by(email: 'maddbuzz@gmail.com')&.update(admin: true)
    user = User.find_or_initialize_by(email: 'maddbuzz@gmail.com')
    user.update(name: 'Developer', admin: true)
  end
end
