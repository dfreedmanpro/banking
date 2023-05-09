require_relative 'enums'

module Banking
  INDIVIDUAL_WITHDRAWL_LIMIT = 1000
  
  class Account
    attr_reader :bank, :owner, :balance, :type, :checking_type
    
    def initialize(bank, owner, type, checking_type, balance)
      @bank = bank
      @owner = owner
      @type = type
      @checking_type = checking_type
      @balance = balance
    end

    def deposit!(amount)
      @balance += amount
    end
    
    def withdraw!(amount)
      unless @type == AccountType::Checking 
        raise 'Can withdraw or transfer from checking account only'
      end

      if @balance < amount
        raise 'Insufficient balance'
      end

      if @@checking_type == CheckingAccountType::Individual && amount > INDIVIDUAL_WITHDRAWL_LIMIT
        raise 'Exceeded withdrawl limit for individual checking account'
      end

      @balance -= amount
    end

    def transfer!(to, amount)
      if to == self
        raise 'Cannot transfer to yourself'
      end

      withdraw!(amount)
      to.deposit!(amount)
    end
  end
end
