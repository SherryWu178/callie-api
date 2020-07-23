class Activity < ApplicationRecord
    has_many :events, :dependent => :delete_all
    has_many :deadlines, :dependent => :delete_all
end