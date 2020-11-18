class Event < ApplicationRecord
    belongs_to :activity
    validates :title, presence: { on: :create }

end
