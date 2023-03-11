# frozen_string_literal: true

ActiveRecord::Base.transaction do
  image_names = %w[food_0 food_1 food_2 food_3 food_4]

  User.create!(email: Faker::Internet.email, name: Faker::Name.name)
  users = User.all

  4.times do
    # Category.create!(name: Faker::Food.unique.ethnic_category)
    Category.create!(name: Faker::Lorem.unique.sentence)
  end
  categories = Category.all

  100.times do
    b = Bulletin.new(
      title: Faker::Food.dish,
      description: Faker::Food.description.slice(..999),
      category: categories.sample,
      user: users.sample,
      state: %i[published under_moderation].sample
    )

    filename = "#{image_names.sample}.jpg"
    b.image.attach(
      io: File.open("test/fixtures/files/#{filename}"),
      filename:
    )
    b.save!
  end
end
