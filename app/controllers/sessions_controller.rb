class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by(email: session[:email].downcase)

    if user&.authenticate(session[:password])
      if user.actived?
          log_in user
          session[:remember_me] == "1" ? remember(user) : forget(user)
          redirect_back_or user
        else
          message = t "signup.account_inactive"
          flash[:warning] = message
          redirect_to root_url
      end
    else
      flash.now[:danger] = t "flash.sign_in_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
