# frozen_string_literal: true

class StatementQuery
  def initialize(relation = Transaction)
    @relation = relation
  end

  # Fetches transactions for a given account for the last N days.
  def account_transactions(account, since = 7.days)
    relation
      .where(created_at: created_at(since))
      .where(belongs_to, account, account)
      .order('created_at ASC')
  end

  private

  attr_reader :relation

  def created_at(since)
    since.days.ago.beginning_of_day..Time.zone.today.end_of_day
  end

  def belongs_to
    'source_account_id = ? OR destination_account_id = ?'
  end
end
