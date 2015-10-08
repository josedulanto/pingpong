class Match < ActiveRecord::Base
  
  belongs_to :player1, class_name: User, foreign_key: :player1_id
  belongs_to :player2, class_name: User, foreign_key: :player2_id
  
  validates :player1, :player2, presence: true
  validate :only_one_unconfirmed_match_per_opponent, on: :create
  validate :win_by_two_points_margin, if: proc{ |match| !match.confirmed }, on: :update
  
  scope :with_players, ->(player1_id, player2_id) { where("(player1_id=? AND player2_id=?) OR (player2_id=? AND player1_id=?)", player1_id, player2_id, player1_id, player2_id) }
  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  
  def winner
    players_ordered_by_score.last
  end
  
  def loser
    players_ordered_by_score.first
  end
  
  private
  
    def win_by_two_points_margin
      errors.add(:base, "The winner should have two points more than its opponent") if (player1_score - player2_score).abs < 2
    end
  
    def only_one_unconfirmed_match_per_opponent
      counter = Match.with_players(player1_id, player2_id).unconfirmed.count
      errors.add(:base, "You are already playing a match against #{player2.email}") if counter > 0
    end
    
    def players_ordered_by_score
      p1 = [player1, player1_score]
      p2 = [player2, player2_score]
      [p1, p2].sort_by{|p| p.last}.map(&:first)
    end
  
end
