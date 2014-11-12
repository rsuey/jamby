task administer_payouts: :environment do
  if [15, 28].include?(Time.now.day)
    Account.find_each(&:transfer_payouts_due!)
  end
end
