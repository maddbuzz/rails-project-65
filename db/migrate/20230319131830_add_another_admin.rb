# frozen_string_literal: true

class AddAnotherAdmin < ActiveRecord::Migration[7.0]
  def change
    user = User.find_or_initialize_by(email: 'al3xander.koval@gmail.com')
    user.update(name: 'Проверяющий', admin: true)
  end
end
