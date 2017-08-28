class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    #debugger   #останавл. программу, открыв. консоль, cnrl-D - выход.
  end

  def new
    @user = User.new
  end

  def create
    #VS @user = User.new(params[:user])   # не окончательная реализация!
    @user = User.new(user_params)
    if @user.save
      # Обработать успешное сохранение
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
