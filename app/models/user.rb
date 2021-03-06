require 'services/pingpong_board'

class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  
  has_many :identities, dependent: :destroy
  has_many :matches_as_player1, foreign_key: :player1_id, class_name: Match
  has_many :matches_as_player2, foreign_key: :player2_id, class_name: Match
  
  attr_accessor :current_identity
  
  # Define what an email should look like
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,:lockable, :timeoutable

  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of :password, within: Devise.password_length, allow_blank: true
  
  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    leaderboard = PingPongBoard.default
    leaderboard.rank_member(id, 0, { email: email, gravatar_url: gravatar_url })
  end
  
  def matches
    matches_as_player1 + matches_as_player2
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    @current_identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : @current_identity.user
    # asdasd
    # Create the user if needed
    if user.nil?
      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified or ['github', 'instagram', 'twitter'].include?(auth.provider)
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the @identity with the user if needed
    if @current_identity.user != user
      @current_identity.user = user
      @current_identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
  def name
    email_verified? ? email : unconfirmed_email
  end
  
  private
  
  def password_required?
    return false if email.blank?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

end