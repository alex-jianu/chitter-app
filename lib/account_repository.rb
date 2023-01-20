class AccountRepository
    def all
        sql = "SELECT * FROM accounts;"

        result_set = DatabaseConnection.exec_params(sql, [])

        @accounts = []

        result_set.each do |rec|
            account = Account.new
            account.id = rec['id']
            account.email = rec['email']
            account.name = rec['name']
            account.username = rec['username']
            account.password = rec['password']

            @accounts << account
        end

        return @accounts
    end

    def create(account)
        sql = "INSERT INTO accounts (email, name, username, password) VALUES ($1, $2, $3, $4)"

        params = [account.email, account.name, account.username, account.password]

        DatabaseConnection.exec_params(sql, params)
    end

end