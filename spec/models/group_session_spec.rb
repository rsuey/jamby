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

  # https://github.com/JackDanger/permanent_records/
  describe 'Soft deletion' do
    describe '.destroy_all' do
      it 'updates deleted_at on all group sessions' do
        datetime = Time.current
        3.times { create(:group_session) }

        Timecop.freeze(datetime) do
          GroupSession.destroy_all
          expect(GroupSession.all.map(&:deleted_at).uniq).to eq([datetime])
        end
      end
    end

    describe '#destroy' do
      it 'updates deleted_at on the group session' do
        datetime = Time.current
        group_session = create(:group_session)

        Timecop.freeze(datetime) do
          group_session.destroy
          expect(group_session.deleted_at).to eq(datetime)
        end
      end
    end
  end
end
