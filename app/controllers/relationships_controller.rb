class RelationshipsController < ApplicationController
  before_action :logged_in_user

  attr_reader :user

  def create
    user = User.find_by id: params[:followed_id]
    current_user.follow user
    un_follow_res
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    un_follow_res
  end

  private

  def un_follow_res
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end
end
