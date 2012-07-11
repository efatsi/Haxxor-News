class VotesController < ApplicationController
  
  before_filter :require_user

  def create
    @votable = find_parent_resource
    @votable.create_vote_by(current_user, params[:direction])
    redirect_to :back
  end


end