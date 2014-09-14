require 'rails_helper'

describe Guest do
  describe '#is_guest?' do
    it 'returns true' do
      expect(Guest.new).to be_is_guest
    end
  end
end
