require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/account_repository'
require_relative 'lib/account'
require_relative 'lib/reply_repository'
require_relative 'lib/reply'
require_relative 'lib/peep_repository'
require_relative 'lib/peep'
require_relative 'lib/database_connection'
require 'pony'

DatabaseConnection.connect()

class Application < Sinatra::Base

  # This allows the app code to refresh
  # without having to restart the server.

  @@peeps = PeepRepository.new.all

  configure :development do
    register Sinatra::Reloader
    also_reload '/public/*'
  end

  Pony.options = {
    :subject => "You have been tagged in a peep!",
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 =>  '587',
      :user_name            => 'chitterlivechat@gmail.com',
      :password             => 'jmydqpzajkwdftnf',
      :authentication       => :login,
      :domain               => 'chitterlivechat.com'
      }
    }

  use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'

  
  get '/' do
    if session[:user] == nil
      session[:user] = Account.new
      session[:user].name = 'Anonymous'
      session[:user].username = 'user' + (AccountRepository.new.all.length+1).to_s
    end

    @user = session[:user]
    return erb(:index)
  end

  get '/peeps/new' do
    @user = session[:user]
    return erb(:new_peep)
  end

  get '/peeps/:id' do
    @user = session[:user]
    @peep = PeepRepository.new.find(params[:id])
    @replies = ReplyRepository.new.find(params[:id])
    return erb(:peep)
  end

  get '/peeps/:id/reply' do
    @user = session[:user]
    @peep = PeepRepository.new.find(params[:id])
    return erb(:reply)
  end

  post '/peeps/:id' do
    @user = session[:user]

    reply = Reply.new
    reply.content = params[:content]
    reply.author = "#{@user.name}(#{@user.username})"
    reply.time = Time.now
    reply.peep_id = params[:id]

    ReplyRepository.new.send(reply)

    new_path = "/peeps/#{params[:id]}"

    return redirect(new_path)
  end

  post '/peeps' do
    @user = session[:user]
    peep = Peep.new
    peep.content = params[:content]
    peep.author = "#{@user.name}(#{@user.username})"
    peep.time = Time.now

    PeepRepository.new.send(peep)

    @peep = PeepRepository.new.all.find{|p| p.time = peep.time && p.content == peep.content}

    params[:content].split(" ").each do |word|
      if AccountRepository.new.all.find{|acc| word.include?(acc.username)}
        tagged_account = AccountRepository.new.all.find{|acc| word.include?(acc.username)}

        Pony.mail :to => "#{tagged_account.email}",
            body: "#{peep.content}\n    ~#{peep.author}\n\nIn case you wanted to know...\n\n٩(˘◡˘)۶\nChitterLiveChat <3"
      end
    end

    @@peeps = PeepRepository.new.all

    return redirect('/')
  end

  get '/admin' do
    @user = session[:user]

    if @user.username == AccountRepository.new.all.find{|acc| acc.username == 'lxRVN'}.username
      @accounts = AccountRepository.new.all.reject{|acc| acc.password == nil}
      return erb(:admin)
    else
      @error = "Nice try... but you ain't ADMIN ;)"
      return erb(:error_login)
    end
  end

  get '/signup' do
    @user = session[:user]
    return erb(:signup)
  end

  post '/signup' do
    @user = session[:user]

    if AccountRepository.new.all.find{|acc| acc.username == params[:username]}
      @error = "This Username is already associated with an account!"
      return erb(:error)
    elsif AccountRepository.new.all.find{|acc| acc.email == params[:email]}
      @error = "This Email is already associated with an account!"
      return erb(:error)
    else
      account = Account.new
      account.name = params[:name]
      account.username = params[:username]
      account.email = params[:email]
      account.password = params[:password]
      AccountRepository.new.create(account)
      return redirect('/login')
    end

  end

  get '/recover' do
    @user = session[:user]
    return erb(:recover)
  end

  post '/recover' do
    @user = session[:user]
    if !AccountRepository.new.all.find{|acc| acc.email == params[:email]}
      @error = "This email is not yet linked to an account!"
      return erb(:error_recover)
    else
      lost_account = AccountRepository.new.all.find{|acc| acc.email == params[:email]}
      Pony.mail :to => "#{lost_account.email}",
            subject: "Here are your Chitter Log In Credentials",
            body: "Username - #{lost_account.username}\nPassword - #{lost_account.password}\n\n\nWrite them down somewhere...\nOr don't....\nI won't tell you how to live your life...(≖_≖ )\n\n\nYOLO\n~ChitterLiveChat <3"
      return redirect('/')
    end
  end

  get '/login' do
    @user = session[:user]
    return erb(:login)
  end

  post '/login' do
    @user = session[:user]
    if params[:username].match(/^user[0-9]+$/)
      @error = "Auto-generated Annonymous Accounts cannot be logged into."
      return erb(:error_login)
    elsif !AccountRepository.new.all.find{|acc| acc.username == params[:username]}
      @error = "This Username is not linked to an account"
      return erb(:error_login)
    elsif params[:password] == AccountRepository.new.all.find{|acc| acc.username == params[:username]}.password
      session[:user] = AccountRepository.new.all.find{|acc| acc.username == params[:username]}
      return redirect('/')
    else
      @error = "Wrong Password"
      return erb(:error_login)
    end
  end

  get '/logout' do
    session[:user] = Account.new
    session[:user].name = 'Anonymous'
    session[:user].username = "user" + (AccountRepository.new.all.length + 1).to_s
    AccountRepository.new.create(session[:user])
    return redirect('/')
  end
end