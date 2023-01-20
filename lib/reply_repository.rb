class ReplyRepository
    def all
        sql = "SELECT * FROM replies;"

        result_set = DatabaseConnection.exec_params(sql, [])

        @replies = []

        result_set.each do |rec|
            reply = Reply.new
            reply.id = rec['id']
            reply.content = rec['content']
            reply.peep_id = rec['peep_id']
            reply.author = rec['author']

            @replies << reply
        end

        return @replies
    end

    def send(reply)
        sql = "INSERT INTO replies (content, peep_id, time, author) VALUES ($1, $2, $3, $4)"

        params = [reply.content, reply.peep_id, reply.time, reply.author]

        DatabaseConnection.exec_params(sql, params)
    end

    def find(peep_id)
        sql = "SELECT * FROM replies WHERE peep_id = $1;"

        params = [peep_id]

        result_set = DatabaseConnection.exec_params(sql, params)

        replies = []

        result_set.each do |res|

            reply = Reply.new
            reply.id = res['id']
            reply.content = res['content']
            reply.peep_id = res['peep_id']
            reply.author = res['author']
            reply.time = res['time']

            replies << reply
        end
        return replies
    end
end