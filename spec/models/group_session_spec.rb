require 'rails_helper'

describe GroupSession do
  describe '#free?' do
    context 'when the price is 0' do
      it 'returns true' do
        group_session = create(:group_session, price: 0)
        expect(group_session).to be_free
      end
    end

    context 'when the price is greater than 0' do
      it 'returns false' do
        group_session = create(:group_session, price: 0.01)
        expect(group_session).to_not be_free
      end
    end
  end
end
