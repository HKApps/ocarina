class ApiAuthenticationService
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  class_attribute :attributes, :instance_writer => false
  self.attributes = []

  def self.attr_accessor(*vars)
    self.attributes += vars
    super
  end

  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :email
  attr_accessor :id
  attr_accessor :image
  attr_accessor :access_token

  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :email,        presence: true
  validates :id,           presence: true
  validates :image,        presence: true
  validates :access_token, presence: true

  def self.user_from_params(params)
    auth = new(params.slice(*self.attributes))
    auth.user_from_facebook
  end

  def initialize(params={})
    super
  end

  def user_from_facebook
    User.where(email: email).first_or_initialize.tap do |user|
      user.email      = email
      user.first_name = first_name
      user.last_name  = last_name
      user.image      = image
      if user.new_record?
        user.save!
        WelcomeMailerWorker.new.async.perform(user.id)
      else
        user.touch
      end

      authentication = user.authentications.where(
        provider: 'facebook',
        uid:      id
      ).first_or_initialize

      authentication.access_token = access_token
      authentication.save!
    end
  end

end
