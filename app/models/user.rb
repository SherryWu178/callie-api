class User < ApplicationRecord
    has_secure_password
    validates :password, presence: { on: :create }
    validates_format_of :password, 
        with:         /
        \A(?=.*[a-z])
        (?=.*[A-Z])
        (?=.*\d)
        (?=.*[@$!%*?&])
        [A-Za-z\d@$!%*?&]
        {6,30}
        \z/x
    validates :email, presence: true, uniqueness: true,
        case_sensitive: false,
        on: :create
    validates_format_of :email, 
        :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create    
    validates :username, presence: true, uniqueness: true,
        length: { maximum: 50 }, 
        on: :create

    has_many :events, dependent: :delete_all
    has_many :activities, dependent: :delete_all
    has_many :deadlines, dependent: :delete_all

end
