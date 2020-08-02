Rails.application.routes.draw do
  resource :users, only: %i[create], path: 'users'
  resource :accounts, only: %i[update], path: 'accounts' do
    post 'deposit'
  end
end
