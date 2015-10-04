
  class Event < ActiveRecord::Base
    belongs_to :conference
    belongs_to :city

    validates :start, :end, :web, presence: true

    def href
      "/events/#{self.id}"
    end

    def embedded_format
      city = self.city
      country = city.country
      continent = country.continent

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
          :href => city.href,
          :code => city.code,
          :name => city.name
        },
        "cc:country" => {
          :href => country.href,
          :code => country.code,
          :name => country.name
        },
        "cc:continent" => {
          :href => continent.href,
          :code => continent.code,
          :name => continent.name
        }
      }
    end
  end
