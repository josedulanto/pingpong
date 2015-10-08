# Create users
leaderboard = Leaderboard.new("pingpong", Leaderboard::DEFAULT_OPTIONS, redis_connection: Redis.current)

50.times do
  user = User.create(email: Faker::Internet.email, password: "password", password_confirmation: "password", confirmed_at: Time.now)
  puts "==> User #{user.email} created successfully"
  leaderboard.rank_member(user.id, 0, { email: user.email })
  puts "==> User #{user.email} added to leaderboard"
end