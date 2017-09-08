require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Неверный адрес электр. почты
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Верный адрес электр. почты
    post password_resets_path, params: { password_reset: { email: @user.email }}
      # Поменялся digest
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Форма сброса пароля
    user = assigns(:user)
    # Неверный адрес эл. почты
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Неактивированная учетная запись (toggle - переключ. true <-> false)
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email:user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #Верный адрес электр. почты, неверный токен
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Верный адрес электр. почты, верный токен
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    # Проверяет наличие тега input с правильными именем, типом и адр. эл. почты
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Недопустимый пароль и подтверждение
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Пустой пароль
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "  ",
                            password_confirmation: "qweqwer" } }
    assert_select 'div#error_explanation'
    # Допустимый пароль и подтверждение
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

end
