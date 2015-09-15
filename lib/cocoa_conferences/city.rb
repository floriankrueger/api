
  class City < ActiveRecord::Base
    belongs_to :country
    has_many :events

    validates :code, :name, presence: true
    validates :code, uniqueness: true

    before_save :capitalize_name

    def self.find_by_code_or_create(code:, name:)

      city = City.where(:code => code).first

      unless city
        city = City.new(:code => code, :name => name)
        unless city.valid?
          raise LocationValidationError, "Unknown city. Please provide the cities’ name in english."
        end
      end

      city
    end

    def capitalize_name
      @name.capitalize!
    end
  end
