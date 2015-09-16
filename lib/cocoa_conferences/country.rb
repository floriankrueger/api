
  class Country < ActiveRecord::Base
    belongs_to :continent
    has_many :cities

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

    def capitalize_name
      name.capitalize!
    end
  end
