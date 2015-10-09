require 'rails_helper'

RSpec.describe Match, type: :model do
  
  it { should validate_presence_of(:player1) }
  it { should validate_presence_of(:player2) }
  it { should belong_to(:player1) }
  it { should belong_to(:player2) }
  
end
