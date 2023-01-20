require "spec_helper"
require "rack/test"
require_relative '../../app'

def account_test_seed
  sql = File.read('./seeds/account_seeds.sql')
  con = PG.connect({host: '127.0.0.1', dbname: 'chitter_db_test'})
  con.exec(sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    account_test_seed
  end

  context "GET /peeps" do
    it "returns all the previous peeps" do
      response = get('/peeps')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Chitter Live Chat</h1>')
    end
  end

  context "GET /peeps/new" do
    it "returns a form to create a new peep" do
      response = get('/peeps/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Create A New Peep</h1>')
    end
  end

  context "POST /peeps" do
    it "returns message that peep has been sent" do
      response = post('/peeps', author: 'anonymous', content: 'hi there :)')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Your Peep Has Been Sent</h1>')
    end
  end

  context "GET /accounts/new" do
    it "returns a form to make a new account" do
      response = get('/accounts/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Create A New Account</h1>')
    end
  end

  context "GET /accounts/new" do
    it "returns a form to make a new account" do
      response = get('/accounts/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Create A New Account</h1>')
    end
  end

  context "POST /accounts" do
    it "returns message that an account has been created" do
      response = post('/accounts', name:'alex', username:'alex', email:'alex@alex.co.uk', password:'alex?')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Your Account Has Been Created</h1>')
    end
  end

  context "GET /login" do
    it "return a form to log in" do
      response = get('/login')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Log Into Your Account</h1>')
    end
  end

  context "POST /login" do
    it "sets the current account if credentials are correct" do
      response = post('/login', username: 'acone', password: 'aconepw')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You have logged in successfully</h1>')
    end
  end

  context "GET /:username/peeps" do
    it "returns the peeps page as a logged in user" do
      response = get('/acone/peeps')

      expect(response.status).to eq(200)
      expect(response.body).to include ("<h2>Welcome, Account One (acone)</h2")
    end
  end

  context "GET /:username/peeps/new" do
    it "returns a form to send a peep as a logged in user" do
      response = get('/acone/peeps/new')

      expect(response.status).to eq(200)
      expect(response.body).to include ("<h2>Send a Peep as Account One (acone)</h2")
    end
  end
end