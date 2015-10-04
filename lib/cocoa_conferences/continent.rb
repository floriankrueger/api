
  class Continent < ActiveRecord::Base
    has_many :countries
    has_many :events, through: :countries

    def self.find_by_code(code:)
      continent = Continent.where(:code => code).first

      unless continent
        raise LocationValidationError, "Invalid continent code '#{code}'. There's a fixed number of continents on this planets, choose one of them: #{Continent.known_continents}"
      end

      continent
    end

    def href
      "/continents/#{self.code}"
    end

    def href_countries
      "#{self.href}/countries"
    end

    def href_events
      "#{self.href}/events"
    end

    def embedded_format
      {
        :_links => {
          :self => { :href => self.href },
          "cc:country" => { :href => "#{self.href}/countries" },
          "cc:event" => { :href => "#{self.href}/events" }
        },
        :code => self.code,
        :name => self.name
      }
    end

    def self.known_continents
      {
        "af" => "Africa",
        "an" => "Antarctica",
        "as" => "Asia",
        "eu" => "Europe",
        "na" => "North America",
        "oc" => "Oceania",
        "sa" => "South America"
      }
    end
  end
