Rails.application.routes.draw do
  resource :users, only: %i[create], path: 'users'
  resource :accounts, only: %i[update], path: 'accounts'
  resource :transactions, only: [], path: 'transactions' do
    post 'deposit'
  end
end
