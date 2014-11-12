task administer_payouts: :environment do
  if [15, 28].include?(Time.now.day)
    Account.find_each { |account| TransferPayouts.transfer(account) }
  end
end
