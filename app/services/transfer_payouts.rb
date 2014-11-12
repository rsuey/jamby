class TransferPayouts
  class << self
    def transfer(account)
      if account.payable? && account.payout_account.present?
        payout_amount = account.total_payout_due

        account.payout_account.transfer(payout_amount)
        account.group_sessions.completed.paid.find_each(&:payout!)
        HostNotifier.payouts_transferred(account, payout_amount).deliver
      end
    end
  end
end
