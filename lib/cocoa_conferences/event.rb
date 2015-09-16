
  class Event < ActiveRecord::Base
    belongs_to :conference
    belongs_to :city

    validates :start, :end, :web, presence: true
  end
