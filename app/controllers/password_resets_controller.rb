class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    return existemail if user
    flash.now[:danger] = t "fenfound"
    render :new
  end

  def edit; end

  def update
    return passwd_empty if params[:user][:password].empty?
    return passwd_noempty if user.update_attributes user_params
    render :edit
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if user
    flash[:danger] = t "fenfound"
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(:reset,
      params[:id])
    redirect_to root_url
  end

  def existemail
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "fsent"
    redirect_to root_url
  end

  def passwd_empty
    user.errors.add password: t("noempty")
    render :edit
  end

  def passwd_noempty
    log_in user
    user.update_attributes reset_digest: nil
    flash[:success] = t "fsuccess_rs"
    redirect_to user
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "fdanger_rs"
    redirect_to new_password_reset_url
  end
end
