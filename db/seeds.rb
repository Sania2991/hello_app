User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Микросообщения
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
User.create!(name: "Sania",
             email: "sania2991@rambler.ru",
             password:              "123456",
             password_confirmation: "123456",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
user = User.find_by(email: "sania2991@rambler.ru")
content = Faker::Lorem.sentence(5)
user.microposts.create!(content: content)

# Взаимоотношения следования:
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
# 1-ый польз. подписыв. на пользователей: с 3 по 51
following.each { |followed| user.follow(followed) }
# пользователиЖ с 4 по 41 подпис. на полученияе сообщ. 1 польз.
followers.each { |follower| follower.follow(user) }