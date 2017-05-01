require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    #your code here
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    prodected!

    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    username = params[:username]
    password = params[:password]

    redirect '/failure' unless login(username, password)

    redirect '/account'
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  patch '/account/withdraw' do
    prodected!

    user_account.withdraw(params[:amount])
    if !user_account.save
     session[:flash] = user_account.errors.full_messages.to_sentence
   end

   redirect '/account'
  end

  patch '/account/deposit' do
    user_account.deposit(params[:amount])
    user_account.save

    redirect '/account'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def login(username, password)
      return if username.empty? || password.empty?

      user = User.find_by(username: username)
      if user && user.authenticate(password)
        session[:user_id] = user.id
      end
    end
  end

  def prodected!
    redirect '/login' unless logged_in?
  end

  def user_account
    @user_account ||= Account.find_or_create_by(user: current_user)
  end
end
