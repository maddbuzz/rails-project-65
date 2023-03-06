# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy, inverse_of: :owner, foreign_key: :owner_id

  validates :email, presence: true
end
