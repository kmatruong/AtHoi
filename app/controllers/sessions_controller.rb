class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params_session[:email].downcase

    if user && user.authenticate(params_session[:password])
      if user.activated?
        login_successfull user
      else
        no_activate
      end
    else
      log_failed
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def login_successfull user
    log_in user
    params_session[:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def params_session
    params[:session]
  end

  private

  def log_failed
    flash.now[:danger] = t "session_danger"
    render :new
  end

  def no_activate
    flash[:warning] = t "message"
    redirect_to root_url
  end
end
