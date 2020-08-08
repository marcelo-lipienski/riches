# frozen_string_literal: true

class DailyDepositQuery
  def initialize(relation = Account)
    @relation = relation
  end

  def deposits
    @relation
      .source_transactions
      .where(
        transaction_type: :credit,
        destination_account: @relation,
        created_at: today
      )
      .sum(&:amount)
  end

  private

  def today
    Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
  end
end
