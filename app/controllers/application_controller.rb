# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorize
    @jwt = JsonWebToken.decode(authorization_header)
    @current_user = User.find(@jwt[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    # It's a good practice to return http not found instead of unauthorized
    render(status: :not_found)
  rescue JWT::DecodeError => e
    render(status: :not_found)
  end

  private

  def authorization_header
    header = request.headers['Authorization']
    header.split(' ').last if header&.include?('Bearer')
  end
end
