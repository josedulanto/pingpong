class MatchesController < ApplicationController
  before_action :set_match, only: [:update, :destroy, :confirm]
  before_action :set_matches, only: [:index]

  # GET /matches
  # GET /matches.json
  def index
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(player1: current_user, player2: User.find(params[:player2]))

    respond_to do |format|
      if @match.save
        format.html { redirect_to matches_path, notice: 'Match was successfully created.' }
        format.json { render :index, status: :created, location: @match }
      else
        set_matches
        format.html { redirect_to matches_path, alert: @match.errors.full_messages.join("<br/>") }
        format.json { render index: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to matches_path, notice: 'Match was successfully updated.' }
        format.json { render :index, status: :ok, location: @match }
      else
        set_matches
        format.html { redirect_to matches_path, alert: @match.errors.full_messages.join("<br/>") }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def confirm
    respond_to do |format|
      if @match.update(confirmed: true)
        base_points = 1.0
        winner = @match.winner
        loser = @match.loser
        
        @winner = @leaderboard.score_and_rank_for(winner.id)
        @loser = @leaderboard.score_and_rank_for(loser.id)
        
        winner_score = case @winner[:rank].to_i <=> @loser[:rank].to_i
          when -1 then 3.0
          when 0
            @leaderboard.rank_member(loser.id, @loser[:score].to_i+base_points)
            base_points
          when 1 then 5.0
          end
        
        @leaderboard.rank_member(winner.id, @winner[:score].to_i+winner_score)
        
        format.html { redirect_to matches_path, notice: 'Match was successfully updated.' }
        format.json { render :index, status: :ok, location: @match }
      else
        set_matches
        format.html { render :index }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end
    
    def set_matches
      @matches = Match.where("player1_id=? OR player2_id=?", current_user, current_user).order("created_at DESC")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:player1_score, :player2_score)
    end
end
