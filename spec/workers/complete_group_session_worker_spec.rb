require './app/workers/complete_group_session_worker'

RSpec.describe CompleteGroupSessionWorker do
  before { Sidekiq::Testing.inline! }
  after { Sidekiq::Testing.disable! }

  it 'completes group sessions' do
    group_session = double(:group_session)

    allow(GroupSession).to receive(:find).with(1) { group_session }
    allow(group_session).to receive(:update_attributes)

    Timecop.freeze(Time.current) do
      CompleteGroupSessionWorker.perform_async(1)
      expect(group_session).to have_received(:update_attributes)
                               .with(ended_at: Time.current)
    end
  end
end
