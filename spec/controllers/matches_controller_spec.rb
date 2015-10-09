require 'rails_helper'

RSpec.describe MatchesController, type: :controller do

  before :each do
    @user = create(:user, :josedulanto)
    sign_in :user, @user
  end
  
  let(:player1) { @user }
  let(:player2) { create(:user) }
  let(:valid_attributes) { attributes_for(:match).merge(player1: player1, player2: player2, player1_score: 11, player2_score: 9) }
  let(:invalid_attributes) { attributes_for(:match).merge(player1: player1, player2: player2, player1_score: 9, player2_score: 7) }

  describe "GET #index" do
    it "assigns all matches as @matches" do
      match = create(:match, valid_attributes)
      get :index
      expect(assigns(:matches)).to eq([match])
    end
  end

  describe "GET #show" do
    it "should not be routable" do
      expect(get: :show).to_not be_routable
    end
  end
  
  describe "GET #new" do
    it "should not be routable" do
      expect(get: :new).to_not be_routable
    end
  end
  
  describe "GET #edit" do
    it "should not be routable" do
      expect(get: :edit).to_not be_routable
    end
  end
  
  describe "POST #create" do
    it "creates a new Match" do
      expect {
        post :create, player2: player2.to_param
      }.to change(Match, :count).by(1)
    end

    it "assigns a newly created match as @match" do
      post :create, player2: player2.to_param
      expect(assigns(:match)).to be_a(Match)
      expect(assigns(:match)).to be_persisted
    end
  
    it "redirects to the index of matches" do
      post :create, player2: player2.to_param
      expect(response).to redirect_to(matches_path)
    end
  end
  
  describe "PUT #update" do
    context "with valid params" do
      let!(:match) { create(:match, valid_attributes) }
      let(:new_attributes) { {player1_score: 13, player2_score: 11} }
  
      it "updates the requested match" do
        put :update, {id: match.to_param, match: new_attributes}
        match.reload
        expect(response).to redirect_to(matches_path)
      end
      
      it "assigns the requested match as @match" do
        put :update, {id: match.to_param, match: new_attributes}
        expect(assigns(:match)).to eq(match)
      end
    end
  
    context "with invalid params" do
      let!(:match) { create(:match, valid_attributes) }
      let(:invalid_attributes) { {player1_score: 9, player2_score: 7} }
      
      it "assigns the match as @match" do
        put :update, {id: match.to_param, match: invalid_attributes}
        expect(assigns(:match)).to eq(match)
      end
  
      it "redirects to the index of matches" do
        put :update, {id: match.to_param, match: invalid_attributes}
        expect(response).to redirect_to(matches_path)
      end
    end
  end
  
  describe "DELETE #destroy" do
    let!(:match) { create(:match, valid_attributes) }
    
    it "destroys the requested match" do
      expect {
        delete :destroy, {id: match.to_param}
      }.to change(Match, :count).by(-1)
    end
  
    it "redirects to the matches list" do
      delete :destroy, {id: match.to_param}
      expect(response).to redirect_to(matches_url)
    end
  end

end
