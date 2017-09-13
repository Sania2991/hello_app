require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # p_515. Проверка кнопки
    assert_select 'input[type=submit]'
    # Недопустимая инфа
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: " " } }
    end
    assert_select 'div#error_explanation'
    # Допустимое представление
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   picture: picture } }
    end
    assert assigns(:current_user).microposts.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Удалить сообщения.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Переход в профиль другого пользователя
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  # Счетчик мкс. в боковой панели
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_url
    assert_match "#{@user.microposts.count} microposts", response.body
    # У пользователя нет сообщений
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A microposts")
    get root_path
    assert_match "1 micropost", response.body
  end

end
