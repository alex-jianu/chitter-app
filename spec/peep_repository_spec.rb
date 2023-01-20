require 'peep'
require 'peep_repository'
require 'database_connection'

def reset_peeps_table
    sql = "TRUNCATE TABLE peeps RESTART IDENTITY"
    con = PG.connect({host: '127.0.0.1', dbname: 'chitter_db_test'})
    con.exec(sql)
end

describe PeepRepository do

    before(:each) do
        reset_peeps_table
    end
    
    it "sends a new peep" do
        repo = PeepRepository.new

        new_peep = Peep.new
        new_peep.content = "First Peep On Chitter!"
        new_peep.time = Time.now
        new_peep.author = 1

        repo.send(new_peep)

        expect(repo.all.length).to eq 1
    end
end