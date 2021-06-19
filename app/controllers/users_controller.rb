class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create, :new]
  before_action :load_user, except: [:create, :new, :index]
  before_action :user_actived, except: [:new, :create, :index]  
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: [:destroy]

  def destroy
    if @user.destroy
      flash[:success] = t "flash.delete_user_success"
    else
      flash[:danger] = t "flash.delete_user_fail"
    end
    redirect_to users_url
  end

  def index
    @users = User.active.paginate(page: params[:page], per_page:
                          Settings.user.per_page)
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "email.info_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "flash.update_profile_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.not_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def user_actived
    redirect_to root_url and return unless @user.actived
  end
end
