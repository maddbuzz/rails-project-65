# frozen_string_literal: true

ActiveRecord::Base.transaction do
  image_names = %w[food_0 food_1 food_2 food_3 food_4]

  u = User.create!(email: Faker::Internet.email, name: Faker::Name.name)

  4.times do
    Category.create!(name: Faker::Food.unique.ethnic_category)
  end
  c = Category.all

  16.times do
    b = Bulletin.new(
      title: Faker::Food.dish,
      description: Faker::Food.description.slice(..999),
      category: c.sample,
      owner: u,
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
