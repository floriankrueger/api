
  class Conference < ActiveRecord::Base
    has_many :events

    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    def self.find_by_name_or_create(name:)

      conference = Conference.where(:name => name).first

      unless conference
        conference = Conference.new(:name => name)
        unless conference.valid?
          raise ConferenceValidationError, "Invalid conference. Please provide the conferences’ name."
        end
      end

      conference
    end

    def href
      "/conferences/#{self.id}"
    end

    def href_events
      "#{self.href}/events"
    end

    def embedded_format
      hash =
      {
        :_links => {
          :self =>      { :href => self.href },
          "cc:event" => { :href => self.href_events }
        },
        :name => self.name
      }

      if self.web
        hash[:web] = self.web
      end

      hash
    end
  end
