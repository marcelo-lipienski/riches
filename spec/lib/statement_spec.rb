# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Statement) do
  context('when account has no transactions') do
    let(:account)   { build(:account)              }
    let(:statement) { described_class.new(account) }

    it { expect(statement.starting_balance).to(eq(account.balance)) }
    it { expect(statement.final_balance).to(eq(account.balance)) }
    it { expect(statement.history[:transactions]).to(be_empty) }
  end

  context('when account has only deposit transactions') do
    let(:account)          { build(:account)                                                        }
    let(:first_deposit)    { build(:deposit, source_account: account, destination_account: account) }
    let(:second_deposit)   { build(:deposit, source_account: account, destination_account: account) }
    let(:starting_balance) { Float(account.balance + first_deposit.amount + second_deposit.amount)  }
    let(:final_balance)    { Float(first_deposit.amount + second_deposit.amount)                    }
    let(:deposits)         { [first_deposit, second_deposit]                                        }
    let(:statement)        { described_class.new(account, deposits)                                 }

    before { account.balance = final_balance }

    it { expect(statement.starting_balance).to(eq(starting_balance)) }
    it { expect(statement.final_balance).to(eq(account.balance)) }
    it { expect(statement.history[:transactions].size).to(eq(deposits.size)) }
  end

  context('when account has only withdrawal transactions') do
    let(:account)           { build(:account)                                                             }
    let(:first_withdrawal)  { build(:withdrawal, source_account: account, destination_account: account)   }
    let(:second_withdrawal) { build(:withdrawal, source_account: account, destination_account: account)   }
    let(:starting_balance)  { Float(account.balance - first_withdrawal.amount - second_withdrawal.amount) }
    let(:final_balance)     { Float(first_withdrawal.amount + second_withdrawal.amount)                   }
    let(:withdrawals)       { [first_withdrawal, second_withdrawal]                                       }
    let(:statement)         { described_class.new(account, withdrawals)                                   }

    before { account.balance = -final_balance }

    it { expect(statement.starting_balance).to(eq(starting_balance)) }
    it { expect(statement.final_balance).to(eq(account.balance)) }
    it { expect(statement.history[:transactions].size).to(eq(withdrawals.size)) }
  end

  context('when account has transfered money to another account') do
    let(:source_account)      { build(:account) }
    let(:destination_account) { build(:account) }

    let(:transfer_out) do
      build(:transfer_out, source_account: source_account, destination_account: destination_account)
    end

    let(:starting_balance) { Float(source_account.balance - transfer_out.amount) }
    let(:final_balance)    { transfer_out.amount                                 }
    let(:statement)        { described_class.new(source_account, [transfer_out]) }

    before { source_account.balance = -final_balance }

    it { expect(statement.starting_balance).to(eq(starting_balance)) }
    it { expect(statement.final_balance).to(eq(source_account.balance)) }
    it { expect(statement.history[:transactions].size).to(eq(1)) }
  end

  context('when account has received money from another account') do
    let(:source_account)      { build(:account) }
    let(:destination_account) { build(:account) }

    let(:transfer_in) do
      build(:transfer_in, source_account: destination_account, destination_account: source_account)
    end

    let(:starting_balance) { Float(source_account.balance + transfer_in.amount)  }
    let(:final_balance)    { transfer_in.amount                                  }
    let(:statement)        { described_class.new(source_account, [transfer_in])  }

    before { source_account.balance = final_balance }

    it { expect(statement.starting_balance).to(eq(starting_balance)) }
    it { expect(statement.final_balance).to(eq(source_account.balance)) }
    it { expect(statement.history[:transactions].size).to(eq(1)) }
  end
end
