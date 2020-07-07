class Activity < ApplicationRecord
    has_many :events
    has_many :deadlines
end