# frozen_string_literal: true

class UserAccountCreationService
  def call
    OpenStruct.new(
      success?: true,
      data: {
        number: account_number,
        agency: random_string,
        limit: account_limit,
        token: random_string
      }
    )
  end

  private

  def account_number
    "#{current_account_number}-#{rand(1..9)}"
  end

  def current_account_number
    return '1000' if first_account?

    Account.last.number[0..3].next
  end

  def first_account?
    Account.count.zero?
  end

  def random_string
    Array.new(4) { rand(1..9).to_s }.join
  end

  def account_limit
    rand(1000..1800)
  end
end
