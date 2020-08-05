# frozen_string_literal: true

class WithdrawalPresenter
  def initialize(withdrawal_options)
    @withdrawal_options = withdrawal_options
  end

  def data
    withdrawal_options.map do |option|
      to_hash(option).delete_if { |_k, v| v.zero? }
    end
  end

  private

  attr_reader :withdrawal_options

  def to_hash(option)
    {
      '50': option.count(50),
      '20': option.count(20),
      '2': option.count(2)
    }
  end
end
