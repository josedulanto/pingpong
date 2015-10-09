module PingPongBoard
  
  def self.default
    Leaderboard.new("pingpong", Leaderboard::DEFAULT_OPTIONS, redis_connection: Redis.current)
  end
  
end