require_relative 'account'

module Banking
  class Bank
    attr_accessor :name

    def initialize(name)
      @name = name
      @accounts = []
    end

    def open_account!(owner, type, checking_type)
      account = Account.new(self, owner, type, checking_type, 0)
      @accounts.push(account)

      account
    end
  end
end
