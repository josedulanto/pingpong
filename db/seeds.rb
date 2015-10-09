require 'services/pingpong_board'
# Create users
leaderboard = PingPongBoard.default
leaderboard.delete_leaderboard

50.times do
  user = User.create(email: Faker::Internet.email, password: "password", password_confirmation: "password", confirmed_at: Time.now)
  puts "==> User #{user.email} created successfully"
  leaderboard.rank_member(user.id, 0, { email: user.email, gravatar_url: user.gravatar_url })
  puts "==> User #{user.email} added to leaderboard"
end