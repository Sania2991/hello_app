if Rails.env.production?
  CarrierWave.configure do |config|
    config.dropbox_app_key = ENV["APP_KEY"]
    config.dropbox_app_secret = ENV["APP_SECRET"]
    config.dropbox_access_token = ENV["ACCESS_TOKEN"]
    config.dropbox_access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    config.dropbox_user_id = ENV["USER_ID"]
    config.dropbox_access_type = "app_folder"
  end
end


# НЕБЕЗОПАСНО!!!:
# if Rails.env.production?
#   CarrierWave.configure do |config|
#     config.dropbox_app_key = "65wno..pv"
#     config.dropbox_app_secret = "0u..wia"
#     config.dropbox_access_token = "5n..ox"
#     config.dropbox_access_token_secret = "e8..li"
#     config.dropbox_user_id = "25..42"
#     config.dropbox_access_type = "app_folder"
#   end
# end


# Для обычного окружения(без пробела!!!):
  # Добавить в /.bashrc   => запустить: $ source .bashrc
  # export APP_KEY="65wnoxrfsp69cpv"
  # export APP_SECRET="0u3qoqaigf8cwia"
  # export ACCESS_TOKEN="5nto6s8jj2wygzox"
  # export ACCESS_TOKEN_SECRET="e82gwakp2e9ucli"
  # export USER_ID="255856942"


# Для Heroku:
  # $ heroku config:set APP_KEY="65wnoxrfsp69cpv"
  # $ heroku config:set APP_SECRET="0u3qoqaigf8cwia"
  # $ heroku config:set ACCESS_TOKEN="5nto6s8jj2wygzox"
  # $ heroku config:set ACCESS_TOKEN_SECRET="e82gwakp2e9ucli"
  # $ heroku config:set USER_ID="255856942"