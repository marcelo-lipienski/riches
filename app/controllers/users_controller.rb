# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.create(user_params)

    head(:internal_server_error) && return unless user.persisted?

    render(json: user, status: :created)
  end

  private

  def user_params
    params.permit(:fullname, :document, :birthdate, :gender, :password)
  end
end
