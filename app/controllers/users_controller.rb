class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      UserMailer.account_activation(user).deliver_now
      flash[:info] = t "finfo"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = user.microposts.paginate page: params[:page]
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "success"
      redirect_to user
    else
      render :edit
    end
  end

  def following
    @title = t "following"
    find_user
    @users = user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t "followers"
    find_user
    @users = user.followers.paginate page: params[:page]
    render "show_follow"
  end

  def destroy
    return unless user.destroy
    flash[:success] = t "delete"
    redirect_to users_url
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:success] = t ".error"
    redirect_to root_path
  end
end
