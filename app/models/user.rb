# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy, inverse_of: :user

  validates :email, presence: true
end
