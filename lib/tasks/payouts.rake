task administer_payouts: :environment do
  if [15, 28].include?(Time.now.day)
    accounts = Account.all.select { |account|
      account.manages_payout_account? && account.payout_account.present?
    }

    accounts.each(&:transfer_payouts_due!)
  end
end
