class LeaderboardController < ApplicationController
  
  before_filter :set_leaderboard
  
  def show
    limit = params.fetch(:limit, 25).to_i
    page = params.fetch(:page, 1).to_i
    @users = @leaderboard.leaders(page, {with_member_data: true})
    
    pager = Kaminari.paginate_array(@users, total_count: @leaderboard.total_members)
    @page_array = pager.page(page).per(limit)
  end
  
end
