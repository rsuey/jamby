require 'rails_helper'

describe GroupSession do
  describe '#broadcast_url' do
    it 'returns the broadcast_id with youtube' do
      group_session = create(:group_session, broadcast_id: 'fooBar')
      expect(group_session.broadcast_url).to eq('http://youtube.com/watch?v=fooBar')
    end
  end

  describe '#live_details_ready?' do
    it 'returns true when live_url and broadcast_id are present' do
      group_session = create(:group_session, live_url: 'present',
                                             broadcast_id: 'here')
      expect(group_session).to be_live_details_ready
    end

    it 'returns false when live_url and broadcast_id are not present' do
      group_session = create(:group_session)
      expect(group_session).to_not be_live_details_ready
    end
  end

  describe '#paid?' do
    context 'when it is free' do
      it 'returns true' do
        group_session = create(:group_session, price: 0)
        expect(group_session).to be_paid(double(:user))
      end
    end

    context 'when it is not free' do
      context 'and the user does not have a payment' do
        it 'returns false' do
          group_session = create(:group_session, price: 1)
          expect(group_session).to_not be_paid(double(:user))
        end
      end

      context 'and the user has a payment' do
        it 'returns true' do
          user = create(:account)
          group_session = create(:group_session, price: 1)
          create(:payment, group_session: group_session, account: user)
          expect(group_session).to be_paid(user)
        end
      end
    end
  end

  describe '#host_name' do
    it 'returns the name of the host' do
      user = create(:user, first_name: 'Foo', last_name: 'Bar')
      group_session = create(:group_session, host: user)

      expect(group_session.host_name).to eq('Foo Bar')
    end
  end

  describe 'can_be_booked_by?' do
    context 'when the user is the host' do
      it 'returns false' do
        user = create(:user)
        group_session = create(:group_session, host: user)
        expect(group_session.can_be_booked_by?(user)).to eq(false)
      end
    end

    context 'when the user is on the guest list' do
      it 'returns false' do
        user = create(:user)
        group_session = create(:group_session)

        Booking.create(group_session, user)
        expect(group_session.can_be_booked_by?(user)).to eq(false)
      end
    end

    context 'when the user is not the host, not guest listed' do
      it 'returns true' do
        user = double(:user)
        group_session = create(:group_session)
        expect(group_session.can_be_booked_by?(user)).to eq(true)
      end
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
        Booking.create(group_session, user)
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
