# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authorize

  # Creates a credit transaction from and to a given user
  #
  # POST /transactions/deposit
  def deposit
    service = DepositService.new(@current_user.account, params[:amount]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(status: :ok)
  end

  # Creates a debit transaction to the user transfering and a credit transaction
  # to the user receiving the transaction
  #
  # POST /transactions/transfer
  def transfer
    service = TransferService.new(@current_user.account, transfer_params).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(status: :ok)
  end

  # Creates a withdrawal request
  #
  # POST /transactions/withdrawal_request
  def withdrawal_request
    service = WithdrawalRequestService.new(@current_user.account, params[:amount]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end

  # Completes a withdrawal request by actually withdrawing from the user's account
  #
  # GET /transactions/withdraw
  def withdraw
    service = WithdrawalService.new(@current_user.account, params[:withdrawal_request]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end

  private

  def transfer_params
    params.permit(:document, :number, :agency, :amount)
  end
end
