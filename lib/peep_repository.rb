class PeepRepository
    def all
        sql = "SELECT * FROM peeps;"

        result_set = DatabaseConnection.exec_params(sql, [])

        @peeps = []

        result_set.each do |rec|
            peep = Peep.new
            peep.id = rec['id']
            peep.content = rec['content']
            peep.time = rec['time']
            peep.author = rec['author']

            @peeps << peep
        end

        return @peeps.reverse
    end

    def send(peep)
        sql = "INSERT INTO peeps (content, time, author) VALUES ($1, $2, $3)"

        params = [peep.content, peep.time, peep.author]

        DatabaseConnection.exec_params(sql, params)
    end

    def find(id)
        sql = "SELECT * FROM peeps WHERE id = $1;"

        params = [id]

        result_set = DatabaseConnection.exec_params(sql, params)

        peep = Peep.new
        peep.id = result_set.first['id']
        peep.content = result_set.first['content']
        peep.time = result_set.first['time']
        peep.author = result_set.first['author']

        return peep
    end
end