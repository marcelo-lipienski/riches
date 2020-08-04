# frozen_string_literal: true

class TransferService
  def initialize(account, params)
    @source = account
    @document = params[:document]
    @account_number = params[:number]
    @account_agency = params[:agency]
    @amount = params[:amount]
  end

  def call
    raise(ArgumentError, 'Amount cannot be less than 0.00') unless amount > 0.00
    raise(ArgumentError, 'Insufficient funds') unless sufficient_funds?
    raise(ActiveRecord::RecordNotFound, 'Destination account could not be found') unless destination?
    raise(ArgumentError, 'Can\'t transfer to yourself') if source.eql?(destination)

    ActiveRecord::Base.transaction do
      transfer_from_source!
      transfer_to_destination!

      source.subtract_balance(amount).save!
      destination.add_balance(amount).save!
    end

    OpenStruct.new(success?: true)
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  rescue ActiveRecord::RecordNotFound => e
    OpenStruct.new(success?: false, error: e.message)
  rescue ActiveRecord::RecordInvalid => e
    # Rescues from ActiveRecord::Base.transaction if needed
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :source, :document, :account_number, :account_agency, :amount

  def sufficient_funds?
    source.balance + source.limit - amount >= 0
  end

  def transfer_from_source!
    Transaction.create!(
      transaction_type: :debit,
      amount: amount,
      source_account: source,
      destination_account: destination
    )
  end

  def transfer_to_destination!
    Transaction.create!(
      transaction_type: :credit,
      amount: amount,
      source_account: source,
      destination_account: destination
    )
  end

  def destination?
    destination.present?
  end

  def destination
    @destination ||= Account
      .includes(:user)
      .where(
        number: account_number,
        agency: account_agency,
        users: { document: document }
      ).first
  end
end
