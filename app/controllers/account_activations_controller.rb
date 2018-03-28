class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      u_activate user
    else
      unon_activate
    end
  end

  private

  def u_activate user
    user.activate
    log_in user
    flash[:success] = t "fsuccess"
    redirect_to user
  end

  def unon_activate
    flash[:danger] = t "fdanger"
    redirect_to root_url
  end
end
