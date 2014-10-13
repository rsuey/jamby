unless defined?(GroupSession)
  class GroupSession; def self.find(id); end; end
end

require './app/workers/complete_group_session_worker'

RSpec.describe CompleteGroupSessionWorker do
  before { Sidekiq::Testing.inline! }
  after { Sidekiq::Testing.disable! }

  it 'completes group sessions' do
    group_session = double(:group_session)

    allow(GroupSession).to receive(:find).with(1) { group_session }
    allow(group_session).to receive(:complete!)

    CompleteGroupSessionWorker.perform_async(1)
    expect(group_session).to have_received(:complete!)
  end
end
