require_relative 'bank'
require_relative 'account'
require_relative 'enums'

# This is a simple bank program.
# A bank has a name.
# A bank also has several accounts.
# An account has an owner and a balance.
# Account types include: Checking, Savings.
# There are two types of Checking accounts: Individual, Money Market.
# Individual checking accounts have a withdrawal limit of 1000 dollars.
#
# Transactions are made on accounts.
# Transaction types include: Deposit, Withdraw, and Transfer.
# Include unit tests that, at a minimum, invoke a deposit, a withdrawal, and transfer.

describe Banking::Account do
  let(:bank) { Bank.new('Bank of America') }
  let(:saving) { bank.open_account!('John', AccountType::Saving) }
  let(:checking_individual) { bank.open_account!('Jane', AccountType::Checking, CheckingAccountType::Individual) }
  let(:checking_money_market) { bank.open_account!('Zack', AccountType::Checking, CheckingAccountType::MoneyMarket) }

  describe '#deposit!' do
    it 'can deposit to any account' do
      saving.deposit!(1000)
      checking_individual.deposit!(2000)
      checking_money_market.deposit!(3000)

      expect(saving.balance).to eq(1000)
      expect(checking_individual.balance).to eq(2000)
      expect(checking_money_market.balance).to eq(3000)
    end
  end

  describe '#withdraw!' do
    before do
      saving.deposit!(1000)
      checking_individual.deposit!(2000)
      checking_money_market.deposit!(3000)
    end

    it 'cannot withdraw from saving account' do
      expect { saving.withdraw!(100) }.to raise_error('Can withdraw or transfer from checking account only')
    end

    it 'cannot withdraw more than balance' do
      expect { checking_individual.withdraw!(10000) }.to raise_error('Insufficient balance')
      expect { checking_money_market.withdraw!(10000) }.to raise_error('Insufficient balance')
    end

    it 'cannot withdraw more than 1000 in individual account' do
      expect { checking_individual.withdraw!(1001) }.to raise_error('Exceeded withdrawl limit for individual checking account')
    end

    it 'can withdraw from individual checking account' do
      checking_individual.withdraw!(300)
      expect(checking_individual.balance).to eq 1700
    end

    it 'can withdraw from money market checking account' do
      checking_money_market.withdraw!(2500)
      expect(checking_money_market.balance).to eq 500
    end
  end

  describe '#transfer!' do
    before do
      saving.deposit!(1000)
      checking_individual.deposit!(2000)
      checking_money_market.deposit!(3000)
    end

    it 'cannot transfer to yourself' do
      expect { checking_individual.transfer!(checking_individual, 100) }.to raise_error('Cannot transfer to yourself')
    end

    it 'cannot transfer from saving account' do
      expect { saving.transfer!(checking_individual, 100) }.to raise_error('Can withdraw or transfer from checking account only')
    end

    it 'cannot transfer more than balance' do
      expect { checking_individual.transfer!(checking_money_market, 10000) }.to raise_error('Insufficient balance')
      expect { checking_money_market.transfer!(checking_individual, 10000) }.to raise_error('Insufficient balance')
    end

    it 'cannot transfer more than 1000 in individual account' do
      expect { checking_individual.transfer!(checking_money_market, 1001) }.to raise_error('Exceeded withdrawl limit for individual checking account')
    end

    it 'can transfer from individual checking account' do
      checking_individual.transfer!(checking_money_market, 300)

      expect(checking_individual.balance).to eq 1700
      expect(checking_money_market.balance).to eq 3300
    end

    it 'can transfer from money market checking account' do
      checking_money_market.transfer!(checking_individual, 300)

      expect(checking_individual.balance).to eq 2300
      expect(checking_money_market.balance).to eq 2700
    end
  end
end
