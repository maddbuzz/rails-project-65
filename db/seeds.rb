# frozen_string_literal: true

FIXTURE_IMAGES_FILE_PATH = 'test/fixtures/files/'

ActiveRecord::Base.transaction do
  image_names = %w[food_0 food_1 food_2 food_3 food_4]

  User.create!(email: Faker::Internet.email, name: Faker::Name.name)
  users = User.all

  8.times do
    Category.create!(name: Faker::Lorem.unique.sentence)
  end
  categories = Category.all

  states = Bulletin.aasm.states.map(&:name)

  200.times do
    b = Bulletin.new(
      title: Faker::Lorem.unique.sentence.slice(...50),
      description: Faker::Lorem.unique.paragraph.slice(...1000),
      user: users.sample,
      category: categories.sample,
      state: states.sample
    )

    filename = "#{image_names.sample}.jpg"
    b.image.attach(
      io: File.open("#{FIXTURE_IMAGES_FILE_PATH}#{filename}"),
      filename:
    )
    b.save!
  end
end
