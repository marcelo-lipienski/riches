# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authorize

  # Updates current user account limit
  # Account limit is used in transfers and withdrawals and should an user use this limit,
  # it's account should be considered in debt (it's sort of like a loan from the bank)
  def update
    service = UpdateAccountLimitService.new(@current_user.account, params[:limit]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end

  # User account balance
  def balance
    render(json: { balance: @current_user.account.balance }, status: :ok)
  end

  # User account statement
  def statement
    service = StatementService.new(@current_user.account, params[:since]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end
end
