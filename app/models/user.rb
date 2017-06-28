class User < ActiveRecord::Base
  belongs_to :group

  def password?(raw_password)
    BCrypt::Password.new(hashed_password) == raw_password
  end

  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
