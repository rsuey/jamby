require 'rails_helper'

describe GroupSession do
  describe '#add_participant' do
    it 'adds a participant to the guest list' do
      group_session = create(:group_session)
      user = create(:user)

      group_session.add_participant(user)
      expect(group_session.guest_list).to include(user)
    end

    it 'does not add duplicates to the guest list' do
      group_session = create(:group_session)
      user = create(:user)

      2.times { group_session.add_participant(user) }
      expect(group_session.guest_list).to eq([user])
    end

    it 'persists the relationship' do
      group_session = create(:group_session)
      user = create(:user)

      group_session.add_participant(user)
      expect(Booking.all.map(&:participant_id)).to include(user.id)
    end
  end

  describe '#booked_by?' do
    context 'when the participant has not booked the session' do
      it 'returns false' do
        group_session = create(:group_session)
        user = create(:user)
        expect(group_session).to_not be_booked_by(user)
      end
    end

    context 'when the participant has booked the session' do
      it 'returns true' do
        group_session = create(:group_session)
        user = create(:user)
        group_session.add_participant(user)
        expect(group_session).to be_booked_by(user)
      end
    end
  end

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
