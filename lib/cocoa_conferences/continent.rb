
  class Continent < ActiveRecord::Base
    has_many :countries

    def self.find_by_code(code:)
      continent = Continent.where(:code => code).first

      unless continent
        raise LocationValidationError, "Invalid continent code '#{code}'. There's a fixed number of continents on this planets, choose one of them: #{Continent.known_continents}"
      end

      continent
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
