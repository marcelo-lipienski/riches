Rails.application.routes.draw do
  resource :users, only: %i[create], path: 'users'

  resource :accounts, only: %i[update], path: 'accounts' do
    get 'balance'
    get 'statement'
  end

  resource :transactions, only: [], path: 'transactions' do
    post 'deposit'
    post 'transfer'
    post 'withdrawal_request'
    post 'withdraw'
  end
end
