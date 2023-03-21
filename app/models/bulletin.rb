# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :draft, initial: true
    state :under_moderation, :published, :rejected, :archived

    event :to_moderate do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end
  end

  belongs_to :category
  belongs_to :user, class_name: 'User', inverse_of: :bulletins

  has_one_attached :image do |attachable|
    # For .variant you need:
    # 1. $ sudo apt install imagemagick libvips
    # 2. gem "image_processing", "~> 1.2"
    attachable.variant :for_form, resize_to_limit: [nil, 100]
    attachable.variant :for_show, resize_to_limit: [400, 300]
  end

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true,
                    content_type: %i[png jpg jpeg],
                    size: { less_than: 5.megabytes }

  scope :by_owner, ->(user) { where(user_id: user.id) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id title state]
  end
end
