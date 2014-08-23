class Customer < ActiveRecord::Base
  has_many :assets, dependent: :destroy
  has_many :shipping_addresses
  has_many :billing_addresses
  has_many :orders
  accepts_nested_attributes_for :shipping_addresses
  accepts_nested_attributes_for :billing_addresses
  # has_many :relationships, foreign_key: "asset_id", dependent: :destroy  
  # has_many :assets, through: :relationships, source: :asset
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, on: :create, length: { minimum: 6 }
  validates :password, on: :update, length: { minimum: 6 }, allow_blank: true

  def Customer.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Customer.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Customer.encrypt(Customer.new_remember_token)
    end     
end