
  class Event < ActiveRecord::Base
    belongs_to :conference
    belongs_to :city

    validates :start, :end, :web, presence: true

    def href
      "/events/#{self.id}"
    end

    def embedded_format
      {
        :_links => { :self => { :href => self.href } },
        :start => self.start.iso8601(3),
        :end => self.end.iso8601(3),
        :web => self.web,
        :_embedded => {
          "cc:conference" => {
            :_links => {
              :self => { :href => "/conferences/#{self.conference.id}" },
              "cc:event" => { :href => "/conferences/#{self.conference.id}/events" }
            },
            :name => self.conference.name
          }
        },
        "cc:city" => {
          :href => "/cities/#{self.city.id}",
          :code => self.city.code,
          :name => self.city.name
        },
        "cc:country" => {
          :href => "/countries/#{self.city.country.id}",
          :code => self.city.country.code,
          :name => self.city.country.name
        },
        "cc:continent" => {
          :href => "/continents/#{self.city.country.continent.id}",
          :code => self.city.country.continent.code,
          :name => self.city.country.continent.name
        }
      }
    end
  end
