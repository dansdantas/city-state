require 'spec_helper'
require 'city-state'
require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require 'pry'

describe CS do
  describe '.cities' do
    before :each do
      Object.send(:remove_const, :CS)
      load 'city-state.rb'
    end

    it 'returns cities for a given state' do
      state = :ak
      country = :us

      cities_fn = File.join(CS::FILES_FOLDER, "cities.#{country.downcase}")
      cities = YAML::load_file(cities_fn).symbolize_keys

      expect(CS.cities(state: state, country: country)).to eq(cities[state.to_s.upcase.to_sym])
    end

    context 'when given only a country' do
      it 'returns all uniq cities' do
        country = :us
        cities_fn = File.join(CS::FILES_FOLDER, "cities.#{country.downcase}")
        cities = YAML::load_file(cities_fn).symbolize_keys
        all_cities = cities.map { |_state, cities| cities }.flatten.uniq

        expect(CS.cities(country: country)).to eq(all_cities)
      end
    end
    
    context 'when state does not exists' do
      it 'return a empty array' do
        expect(CS.cities(state: :bla)).to eq([])
      end
    end

    context 'when country does not exists' do
      it 'returns an empty array' do
        expect(CS.cities(country: :bla)).to eq([])
      end
    end
  end
end
