# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authorize
  before_action :set_account, except: [:authorize]

  def update
    service = UpdateAccountLimitService.new(@account, params[:limit]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end

  def deposit
    service = DepositService.new(@account, params[:amount]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(status: :ok)
  end

  private

  def set_account
    @account = @current_user.account
  end
end
