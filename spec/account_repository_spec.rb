require 'account'
require 'account_repository'
require 'database_connection'

def reset_accounts_table
    sql = "TRUNCATE TABLE accounts RESTART IDENTITY"
    con = PG.connect({host: '127.0.0.1', dbname: 'chitter_db_test'})
    con.exec(sql)
end

def account_test_seed
    sql = File.read('./seeds/account_seeds.sql')
    con = PG.connect({host: '127.0.0.1', dbname: 'chitter_db_test'})
    con.exec(sql)
end

describe AccountRepository do

    before(:each) do
        reset_accounts_table
    end

    it "creates a new account" do
        repo = AccountRepository.new

        new_account = Account.new
        new_account.email = "first_account@makersacademy.com"
        new_account.name = "First Account"
        new_account.username = "account1"
        new_account.password = "password1"

        repo.create(new_account)

        expect(repo.all.length).to eq 1
    end

    it "finds an account by username" do
        repo = AccountRepository.new

        account_test_seed

        expect(repo.find_by_username('actwo').name).to eq "Account two"
    end

    it "finds an account by email" do
        repo = AccountRepository.new

        account_test_seed

        expect(repo.find_by_email('ac_two@makersacademy.co.uk').name).to eq "Account two"
    end
end