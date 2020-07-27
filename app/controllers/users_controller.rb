# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    service = UserRegistrationService.new(user_params, address_params).call

    head(:internal_server_error) && return unless service.success?

    render(json: service.data, status: :created)
  end

  private

  def user_params
    params.permit(:fullname, :document, :birthdate, :gender, :password)
  end

  def address_params
    params.require(:address).permit(
      :country,
      :state,
      :city,
      :district,
      :street,
      :number,
      :complement,
      :zip_code
    )
  end
end
