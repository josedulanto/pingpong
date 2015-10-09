require 'rails_helper'

RSpec.describe LeaderboardController, type: :controller do
  before :each do
    @user = create(:user, :josedulanto)
    sign_in :user, @user
  end
  
  describe "GET #show" do
    let(:leaderboard) { PingPongBoard.default }
    
    it "should render the show template" do
      get :show
      expect(response).to render_template(:show)
    end
    
    it "assigns the default leaderboard as @leaderboard" do
      get :show
      expect(assigns(:leaderboard)).to be_a(Leaderboard)
    end
    
    describe "leaderboard" do
      let(:users) { create_list(:user, 50) }
      
      it "assigns the leaders for page 1 as @users" do
        get :show
        users = leaderboard.leaders(1, {with_member_data: true})
        expect(assigns(:users)).to eq(users)
      end
      
      describe "pagination" do
        it "assigns the leaders for page 2 as @users" do
          get :show, page: 2
          users = leaderboard.leaders(2, {with_member_data: true})
          expect(assigns(:users)).to eq(users)
        end
        
        it "assigns an array of pages as @page_array" do
          get :show
          users = leaderboard.leaders(1, {with_member_data: true})
          page_array = users[0..25]
          expect(assigns(:page_array)). to eq(page_array)
        end
      end
    end
  end
end
