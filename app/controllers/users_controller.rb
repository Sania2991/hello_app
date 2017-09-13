class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
<<<<<<< HEAD
    @microposts = @user.microposts.paginate(page: params[:page])
=======
    redirect_to root_url and return unless @user.activated?   # 454
>>>>>>> Chapter_10_exercices
    #debugger   #останавл. программу, открыв. консоль, cnrl-D - выход.
  end

  def new
    #debugger
    @user = User.new
  end

  def create
    #VS @user = User.new(params[:user])   # не окончательная реализация!
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check yout email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # def destroy
  #   log_out if logged_in?
  #   redirect_to root_url
  # end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user     #VS redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])  #where!
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Предварительные фильтры

    # # Подтверждает вход пользователя.
    # def logged_in_user
    #   перенесли в application_controller, нужно и для Microposts   # p_481
    # end

    # Подтверждает права пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Подтверждение наличия администр.  привилегий
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end