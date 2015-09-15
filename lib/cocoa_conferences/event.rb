
  class Event < ActiveRecord::Base
    belongs_to :conference
    belongs_to :city
  end
