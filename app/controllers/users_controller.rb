class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
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
      log_in @user
      flash[:success] = "Welcome to the Sample App!"    # кратковр. сообщение
      redirect_to @user     #VS redirect_touser_url(@user)
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
