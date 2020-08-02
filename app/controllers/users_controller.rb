# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = UserRegistrationService.new(user_params, address_params).call

    unless user.success?
      render(json: { error: user.error }, status: :bad_request)
      return
    end

    render(json: user.data, status: :created)
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
