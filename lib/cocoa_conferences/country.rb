
  class Country < ActiveRecord::Base
    belongs_to :continent
    has_many :cities
    has_many :events, through: :cities

    validates :code, :name, presence: true
    validates :code, uniqueness: true

    before_save :capitalize_name

    def self.find_by_code_or_create(code:, name:)

      country = Country.where(:code => code).first

      unless country
        country = Country.new(:code => code, :name => name)
        unless country.valid?
          raise LocationValidationError, "Unknown country. Please provide the countries’ name in english."
        end
      end

      country
    end

    def href
      "/countries/#{self.code}"
    end

    def cities_href
      "#{self.href}/cities"
    end

    def events_href
      "#{self.href}/events"
    end

    def embedded_format
      {
        :_links => {
          :self => { :href => self.href },
          "cc:continent" => { :href => self.continent.href },
          "cc:city" => { :href => self.cities_href },
          "cc:event" => { :href => "#{self.href}/events" }
        },
        :code => self.code,
        :name => self.name
      }
    end

    def capitalize_name
      name.capitalize!
    end
  end
