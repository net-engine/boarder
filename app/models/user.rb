class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Authentication

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = User.create(name:     auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         password: Devise.friendly_token[0, 20])
    end

    user
  end
end
