json.array!(@matches) do |match|
  json.extract! match, :id, :player1, :player2, :player1_score, :player2_score, :confirmed
  json.url match_url(match, format: :json)
end
