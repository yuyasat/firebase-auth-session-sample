class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

  # def password_required?
  #   false
  # end

  # def email_required?
  #   false
  # end
end

