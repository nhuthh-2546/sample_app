class AccountActivationsController < ApplicationController
  before_action :get_user

  def edit
    if !@user.actived? && @user.authenticated?(:active, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "flash.account_active_success"
      redirect_to @user
    else
      flash[:danger] = t "flash.account_active_fail"
      redirect_to root_url
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end
end
