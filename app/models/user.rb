class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format:   { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true


  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Возвращает true, если указанный токен соответствует дайджесту.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Активирует уч. запись.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)   #1 обращ. к БД
      # update_attribute(:activated,    true)    # без self., т.к. внутри модели
      # update_attribute(:activated_at, Time.zone.now)
  end

  # Посылает письмо со ссылкой на стр. активации
  def send_activation_email
    UserMailer.account_activation(self).deliver_now     # Заменили @user на self
  end

  # Устанавливает атрибуты для сроса пароля.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                  reset_sent_at: Time.zone.now)   # ОБРАТИ НА :  !!!
      # update_attribute(:reset_digest,  User.digest(reset_token))
      # update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Посылает письмо со ссылкой на форму ввода нового пароля
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true, если время для сброса пароля истекло
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Определяет прото-ленту.
  def feed
    #- p_559. Micropost.where("user_id = ?", id)
    #- неэффективна, если > 5000 чел.
    Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    # following_ids = "SELECT followed_id FROM relationships
    #                  WHERE follower_id = :user_id"
    # Micropost.where("user_id IN (#{following_ids})
    #                  OR user_id = :user_id", user_id: id)
  end

  # Выполняет подписку на сообщения пользователя
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Отменяет подписку на сообщения пользователя
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Возвращает true, если тек. пользователь читает
  def following?(other_user)
    following.include?(other_user)
  end

  private
  # Преобразует адрес электронной почты в нижний регистр.
  def downcase_email
    self.email = email.downcase
  end

  # Создает и присваивает токен активации и его дайджест
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  class << self

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Метод создание токена, который возвращ. случ. токен (app/models/user.rb):
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

end
